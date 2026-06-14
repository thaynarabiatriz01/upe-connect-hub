const API_URL = 'http://localhost:8000';

document.addEventListener('DOMContentLoaded', async () => {
    const token = localStorage.getItem('upe_token');
    const userData = JSON.parse(localStorage.getItem('upe_user') || '{}');
    
    if (!token || userData.role !== 'Monitor') {
        alert("🔒 Acesso Restrito a Monitores.");
        window.location.href = 'index.html';
        return;
    }

    document.getElementById('monitor-name').textContent = `${userData.name} (${userData.role})`;

    document.getElementById('logout-btn').addEventListener('click', () => {
        localStorage.clear();
        window.location.href = 'index.html';
    });

    try {
        const response = await fetch(`${API_URL}/monitor/meus_dados`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (!response.ok) throw new Error("Erro ao buscar dados do monitor.");

        const dados = await response.json();
        
        document.getElementById('m-nome').textContent = dados.nome;
        document.getElementById('m-email').textContent = dados.email;
        document.getElementById('m-mat').textContent = dados.matricula || 'Não informada';
        document.getElementById('m-tipo').textContent = dados.nome_tipo;

    } catch (error) {
        console.error(error);
        alert(error.message);
    }
});
