import json
import re
from langchain_community.llms import Ollama
import datetime

# LLM'i bir kere oluşturup her yerde kullanıyoruz.
llm = Ollama(model="gemma2:9b")

def surgical_json_extractor(text: str) -> dict:
    """LLM'in ürettiği metinden JSON'ı cerrahi hassasiyetle çıkaran ve onaran fonksiyon."""
    print(f"--- LLM'den Gelen Ham Cevap ---\n{text}\n-----------------------------")
    match = re.search(r'```(json)?\s*({.*?})\s*```', text, re.DOTALL)
    if match:
        json_str = match.group(2)
    else:
        start = text.find('{')
        end = text.rfind('}')
        if start != -1 and end > start:
            json_str = text[start:end+1]
        else:
            print("KRİTİK HATA: Metinde JSON formatı bulunamadı.")
            return {"action": "error", "parameters": {"message": "Asistanın cevabı anlaşılamadı."}}
    try:
        fixed_str = re.sub(r',\s*([}\]])', r'\1', json_str)
        return json.loads(fixed_str)
    except json.JSONDecodeError as e:
        print(f"KRİTİK HATA: JSON parse edilemedi. Hata: {e}")
        return {"action": "error", "parameters": {"message": "Asistanın cevabı hatalı formatta."}}

def sanitize_parameters(params: dict) -> dict:
    """LLM'den gelen parametrelerdeki çöp kelimeleri %100 garantili ve AKILLICA temizler."""
    if not params:
        return params
    stop_words = [
        "ekle", "oluştur", "sil", "kaldır", "çıkar", "tamamla", "bitir", 
        "güncelle", "değiştir", "görevini", "görevi", "görev", "işini", "işi"
    ]
    notes_stop_words = ["notu", "not olarak", "not"]
    if 'taskName' in params and params['taskName']:
        words = params['taskName'].split()
        clean_words = [word for word in words if word.lower() not in stop_words]
        params['taskName'] = " ".join(clean_words).strip()
    if 'notes' in params and params['notes']:
        words = params['notes'].split()
        clean_words = [word for word in words if word.lower() not in notes_stop_words]
        params['notes'] = " ".join(clean_words).strip()
    return params

# =============================================================================
# === SADECE BU FONKSİYON DEĞİŞTİ - NİHAİ TARİH HESAPLAMA MANTIĞI ============
# =============================================================================
def parse_turkish_date(text: str | None) -> str | None:
    """ "haftaya cuma" gibi ifadeleri her koşulda doğru hesaplar."""
    if not text: return None
    today = datetime.date.today()
    text = text.lower().replace("haftanın", "haftaya").replace("günü", "").replace("sabah", "").strip()
    
    if "bugün" in text or "bu akşam" in text: return today.strftime('%Y-%m-%d')
    if "yarın" in text: return (today + datetime.timedelta(days=1)).strftime('%Y-%m-%d')
    
    days_tr = {"pazartesi": 0, "salı": 1, "çarşamba": 2, "perşembe": 3, "cuma": 4, "cumartesi": 5, "pazar": 6}
    target_day = -1
    for day, index in days_tr.items():
        if day in text:
            target_day = index
            break
            
    if target_day != -1:
        today_weekday = today.weekday()
        days_ahead = target_day - today_weekday
        
        # Eğer kullanıcı "haftaya" veya "gelecek" dediyse,
        # bugünün hangi gün olduğuna bakmaksızın, direkt 7 gün sonrasını hesapla.
        if "haftaya" in text or "gelecek" in text:
            days_ahead += 7
        # Eğer "haftaya" demediyse VE istenen gün geçmişte kaldıysa (veya bugünse),
        # bir sonraki haftaya atla.
        elif days_ahead <= 0:
            days_ahead += 7
            
        return (today + datetime.timedelta(days=days_ahead)).strftime('%Y-%m-%d')
        
    print(f"UYARI: '{text}' ifadesi bir tarihe çevrilemedi.")
    return None

def invoke_agent(user_input: str) -> dict:
    
    prompt = f"""
    ROLEPLAY as Extractor-9000, a hyper-precise data extraction robot.
    PRIMARY DIRECTIVE: Convert the user's Turkish command into a JSON object.

    **EXTRACTION RULES:**
    1.  **ACTION (Top Priority):** First, determine the action.
        - "ekle", "oluştur", "koy" -> `action`: "addtask"
        - "sil", "kaldır" -> `action`: "deletetask"
        - "tamamla", "bitir" -> `action`: "completetask"
        - "güncelle", "değiştir", "taşı", "al" -> `action`: "updatetask"
    2.  **`taskName` (The Target):** For ALL actions, extract the name of the task being referred to.
        - "ders görevini sil" -> `taskName`: "ders"
        - "toplantıyı yarına taşı" -> `taskName`: "toplantı"
    3.  **NEW VALUES (for updatetask only):**
        - If the user provides a new title, extract it into `newTitle`.
          - "toplantı görevini proje sunumu olarak değiştir" -> `taskName`: "toplantı", `newTitle`: "proje sunumu"
        - If the user provides a new date or time, extract them into `relativeDate` and `time`.
    4.  **CLEAN `notes`**: Extract notes. Remove the trigger keyword "not".
    5.  **RAW `relativeDate`**: Extract the date expression EXACTLY as said ("pazar günü", "yarın"). DO NOT calculate.
    6.  **`time`**: Extract time in HH:MM format.

    **OUTPUT FORMAT:**
    {{
      "action": "ACTION_NAME",
      "parameters": {{ 
        "taskName": "...", 
        "relativeDate": "...", 
        "time": "...", 
        "notes": "...",
        "newTitle": "..."
      }}
    }}

    ---
    **User Command:** "{user_input}"
    ---
    Your JSON Output:
    """

    print(f"--- LLM'e Gönderilen Komut ---\nKullanıcı: {user_input}\n-----------------------------")
    response_text = llm.invoke(prompt)
    
    result = surgical_json_extractor(response_text)
    
    if result.get("action") != "error" and "parameters" in result:
        params = result["parameters"]
        print(f"--- Temizlik Öncesi Parametreler ---\n{params}")
        params = sanitize_parameters(params)
        print(f"--- Temizlik Sonrası Parametreler ---\n{params}")
        relative_date_text = params.pop("relativeDate", None)
        final_date = parse_turkish_date(relative_date_text)
        params["dueDate"] = final_date
        params.setdefault("duration", None)
        params.setdefault("remind", None)
        params.setdefault("repeat", "None")

    print("--- Nihai, Temizlenmiş ve Hesaplanmış JSON ---")
    print(json.dumps(result, indent=2, ensure_ascii=False))
    print("-----------------------------")
    
    return result

if __name__ == "__main__":
    print("Görev Asistanı Agent'ı (v15 - Son Düzeltme). (Çıkmak için 'q' yazın)")
    while True:
        user_input = input("\nKomut: ")
        if user_input.lower() == 'q':
            break
        invoke_agent(user_input)