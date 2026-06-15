from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os
from routers import auth, vagas, admin, docente, monitor, usuarios, eventos, empresas

app = FastAPI(title="API - UPE Connect Hub")

# Configurar CORS para permitir que o Frontend chame o Backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Permite acesso de qualquer URL local (ajustar em produção)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Registrando as rotas da API
app.include_router(auth.router, prefix="/auth", tags=["Autenticação"])
app.include_router(usuarios.router, prefix="/usuarios", tags=["Usuários"])
app.include_router(vagas.router, prefix="/vagas", tags=["Vagas"])
app.include_router(admin.router, prefix="/admin", tags=["Administração"])
app.include_router(docente.router, prefix="/docente", tags=["Docentes e Pesquisadores"])
app.include_router(monitor.router, prefix="/monitor", tags=["Monitores"])
app.include_router(eventos.router, prefix="/eventos", tags=["Eventos"])
app.include_router(empresas.router, prefix="/empresas", tags=["Empresas"])

# Servir os arquivos estáticos do Frontend na raiz do servidor
frontend_path = os.path.join(os.path.dirname(__file__), "..", "frontend")
if os.path.exists(frontend_path):
    app.mount("/", StaticFiles(directory=frontend_path, html=True), name="frontend")
