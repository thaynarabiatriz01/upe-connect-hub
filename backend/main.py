from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import auth, vagas, admin, docente, monitor, usuarios

app = FastAPI(title="API - UPE Connect Hub")

# Configurar CORS para permitir que o Frontend chame o Backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Permite acesso de qualquer URL local (ajustar em produção)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Registrando as rotas
app.include_router(auth.router, prefix="/auth", tags=["Autenticação"])
app.include_router(usuarios.router, prefix="/usuarios", tags=["Usuários"])
app.include_router(vagas.router, prefix="/vagas", tags=["Vagas"])
app.include_router(admin.router, prefix="/admin", tags=["Administração"])
app.include_router(docente.router, prefix="/docente", tags=["Docentes e Pesquisadores"])
app.include_router(monitor.router, prefix="/monitor", tags=["Monitores"])

@app.get("/")
def read_root():
    return {"message": "UPE Connect Hub API está rodando!"}
