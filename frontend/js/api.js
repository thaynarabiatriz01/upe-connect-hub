const API_URL = 'http://localhost:8000';

document.getElementById('login-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const errorDiv = document.getElementById('error-message');
    const loginBtn = document.getElementById('login-btn');
    const btnSpan = loginBtn.querySelector('span');

    // Reset UI
    errorDiv.textContent = '';
    loginBtn.classList.add('loading');
    btnSpan.textContent = 'Autenticando...';

    try {
        const response = await fetch(`${API_URL}/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ email, password })
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.detail || 'Erro ao realizar login.');
        }

        // Sucesso: Salvar token
        localStorage.setItem('upe_token', data.access_token);
        localStorage.setItem('upe_user', JSON.stringify({
            name: data.user_name,
            role: data.user_type
        }));

        btnSpan.textContent = 'Sucesso!';
        loginBtn.style.backgroundColor = '#10B981'; // Green

        // Redirecionamento RBAC (Role-Based Access Control)
        setTimeout(() => {
            alert(`Bem-vindo(a), ${data.user_name}! Autenticação validada pelo Banco de Dados.`);
            
            // Decisão de Roteamento com base no Perfil do Banco
            const role = data.user_type;
            if (role === 'Administrador') {
                window.location.href = 'admin.html';
            } else if (role === 'Professor' || role === 'Coordenador') {
                window.location.href = 'professor.html';
            } else if (role === 'Pesquisador') {
                window.location.href = 'pesquisador.html';
            } else if (role === 'Monitor') {
                window.location.href = 'monitor.html';
            } else {
                window.location.href = 'dashboard.html';
            }
        }, 800);

    } catch (error) {
        errorDiv.textContent = error.message;
        btnSpan.textContent = 'Entrar no Portal';
        loginBtn.classList.remove('loading');
    }
});
