# Documento de Futuras Implementações (Backlog)

Este documento elenca itens arquiteturais e de negócio que foram identificados na auditoria, mas que não compõem o escopo de entrega atual da disciplina. Eles deverão ser priorizados em uma futura versão `v2.0` do sistema.

## 1. Segurança e Privacidade (Adequação LGPD)

> [!WARNING]
> A legislação de proteção de dados exige rigor com informações pessoalmente identificáveis.

- **Criptografia de Senhas (Hashing):** O sistema salva as senhas em texto puro. Futuramente, deverá ser implementada a biblioteca `passlib[bcrypt]` para geração de `hashes` seguros e "Salts" (evitando Rainbow Tables). Ninguém (nem mesmo o DBA) deve ser capaz de ler a senha original.
- **Consentimento Expresso:** Os formulários de registro devem contar com um *Checkbox* obrigatório atrelando a ação do usuário aos **Termos de Uso** e **Política de Privacidade** da instituição.
- **Anonimização de Logs:** Implementar mecanismos de Direito ao Esquecimento. Quando um usuário for removido, seu identificador nos JSONs de log na tabela `auditoria` deve ser permanentemente anonimizado, sem destruir o histórico quantitativo da ação.

## 2. Refinamentos Técnicos

- **Autenticação de Dois Fatores (2FA):** Para perfis de alto privilégio como `Administrador`, adicionar uma segunda camada de segurança.
- **Sistema de Recuperação de Senha:** Módulo de envio de e-mails (`SMTP`) contendo links de redefinição de senha com validade de tempo expirável para alunos e professores.
- **Dashboard Estatístico Gráfico:** Integrar `Chart.js` na área Administrativa para exibição de métricas ao invés de apenas números puros (Média de candidaturas por mês, Alunos vs Estágios, etc).
