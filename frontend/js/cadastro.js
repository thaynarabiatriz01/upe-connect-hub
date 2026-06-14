const API_URL = 'http://localhost:8000';

document.getElementById('cadastro-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const errorBox = document.getElementById('error-box');
    const btn = document.getElementById('btn-cadastrar');
    const btnText = document.getElementById('btn-text');
    
    errorBox.textContent = '';
    
    btn.classList.add('loading');
    btnText.textContent = 'Enviando Dados...';
    btn.disabled = true;

    // Prepara os dados pro backend
    const payload = {
        nome: document.getElementById('nome').value,
        email: document.getElementById('email').value,
        senha: document.getElementById('senha').value,
        matricula: document.getElementById('matricula').value,
        telefone: document.getElementById('telefone').value,
        id_tipo_usuario: parseInt(document.getElementById('tipo').value)
    };

    try {
        const response = await fetch(`${API_URL}/auth/register`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.detail || 'Falha na comunicação com o servidor.');
        }

        alert("Seu cadastro foi recebido com sucesso no banco de dados da UPE!\n\nNo entanto, sua conta está PENDENTE. Você precisará aguardar um Administrador validar o seu perfil para poder acessar o sistema.");
        window.location.href = 'index.html';

    } catch (error) {
        errorBox.textContent = error.message;
        btn.classList.remove('loading');
        btnText.textContent = 'Solicitar Acesso à Plataforma';
        btn.disabled = false;
    }
});
