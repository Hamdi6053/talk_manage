from fastapi import FastAPI
from pydantic import BaseModel
from agent_main import invoke_agent # agent_main.py dosyasını import ettik burada,

# FastAPI uygulamasını başlat
app = FastAPI(
    title="Görev Asistanı API",
    description="Flutter uygulaması için LangChain tabanlı görev yönetimi agent'ı.",
    version="1.0.0",
)

# Gelen isteğin gövdesinin nasıl olacağını tanımlıyoruz
class CommandRequest(BaseModel):
    text: str

# Flutter'dan POST isteği alacak olan endpoint'imiz
@app.post("/process_command", summary="Sesli Komutu İşle")
async def process_command(request: CommandRequest):
    """
    Flutter'dan gelen sesli komut metnini alır,
    LangChain agent'ına işlettirir ve sonucu JSON olarak döner.
    """
    print(f"API'ye Gelen Komut: '{request.text}'")
    result_json = invoke_agent(request.text)
    print(f"Agent'tan Dönen Cevap: {result_json}")
    return result_json