import sys
try:
    import pypdf
    with open(r'd:\MEGA\Apps - LC\upe-connect-hub\docs\01_requisitos.pdf', 'rb') as f:
        reader = pypdf.PdfReader(f)
        text = ''
        for page in reader.pages:
            text += page.extract_text() + '\n'
        print(text)
except Exception as e:
    print(f"Error: {e}")
