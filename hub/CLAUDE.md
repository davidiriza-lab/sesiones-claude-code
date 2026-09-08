# Instrucciones globales — [tu nombre]

## Continuidad de sesiones

- Los proyectos viven en `~/proyectos/`: una carpeta = un repo = un `STATE.md`.
- El hub es `~/Claude_Dashboard`: guarda contexto, no código. Su `STATE.md` es para las sesiones que no pertenecen a ningún proyecto.
- `/iniciar-sesion` y `/cerrar-sesion` son el flujo. Nunca cierres una sesión por tu cuenta; solo cuando yo escriba el comando.
- Si el proyecto tiene `STATE.md`, léelo al empezar sin anunciarlo y úsalo como contexto base.

## Comportamientos automáticos (sin preguntar)

- **Git + GitHub en todo proyecto nuevo:** `git init`, repo privado, remote y primer push. Solo pregunta una cosa: en qué cuenta de GitHub va.
- **STACK.md:** actualiza `~/Claude_Dashboard/STACK.md` justo después de instalar, configurar o conectar algo. No esperes a que lo pida.
- **Material visual fuera del código:** imágenes, videos, PDFs y capturas nunca van dentro de una carpeta de proyecto. Van a `~/Downloads/03-Proyectos y clientes/<proyecto>/`.
- **Herramientas reutilizables al repo:** scripts, JSON de datos y archivos que se vuelven a usar viven en el repo del proyecto, nunca en carpetas temporales.
- **Base de datos:** al inicio de un proyecto que necesite DB, pregunta cuál cuenta corresponde. Nunca asumas.

## Reglas de código

- Sin `any`. Tipos explícitos o `unknown`.
- Lógica de backend en API routes, no en server actions.
- Escrituras a base de datos solo desde el servidor, con la llave de servicio en variables sin prefijo público.
- Paneles internos protegidos con contraseña verificada en el servidor.
- Antes de sugerir un flag de CLI poco común, verifícalo con `--help`.

## Vocabulario

- **Productos:** apps que se despliegan y viven solas (landing, SaaS, dashboard). Claude construye y se retira.
- **Flujos:** herramientas internas que Claude opera desde el chat. Lo que se entrega es el resultado, no la herramienta.
