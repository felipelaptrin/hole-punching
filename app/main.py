from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
import uvicorn

app = FastAPI(
    title="static"
)

@app.get("/", response_class=HTMLResponse)
def home():
    return """
        <html>
            <body>
                Hello world!
            </body>
        </html>
    """

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000)