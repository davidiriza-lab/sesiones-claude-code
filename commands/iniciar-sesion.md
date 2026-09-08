---
description: Carga el contexto de un proyecto (lee STATE.md) para retomar donde se dejó. Acepta el nombre del proyecto como argumento o lista los disponibles.
argument-hint: [proyecto]
---

# /iniciar-sesion [proyecto]

## Paso 0 — Exigir conversación limpia
Este comando reconstruye el contexto DESDE STATE.md. Si esta conversación ya trae
trabajo previo (otro tema, otro proyecto, una sesión ya cerrada), NO cargues nada.
Responde solo esto y espera:

  ⛔ Esta conversación ya viene cargada.
  Escribe /clear y vuelve a lanzar /iniciar-sesion [proyecto].

Si el usuario responde que quiere continuar aquí, hazlo sin insistir.

## Paso 1 — Resolver el proyecto
- Con argumento: busca la carpeta en ~/proyectos/[argumento]; acepta coincidencia parcial;
  si hay ambigüedad muestra opciones.
- Sin argumento: si el directorio actual está dentro de ~/proyectos/, úsalo.
  Si no, lista las carpetas de ~/proyectos/ numeradas y pregunta cuál.

## Paso 2 — Cargar contexto
1. Lee STATE.md y extrae la sección "Última sesión" (la primera del archivo).
2. Complementa con git: últimos 3 commits y archivos con cambios sin commitear.
3. Revisa trabajo externo: `git fetch origin --quiet` y lee `git status -sb`.
   - behind N con copia local limpia → `git pull --ff-only` y resume qué llegó (por tema).
   - behind N con cambios propios → NO hagas pull; repórtalo en "Antes de empezar".
   - ahead N → hay commits sin subir; repórtalo.
4. Health check (reporta SOLO si algo falla):
   - package.json sin node_modules → "instalar deps con npm install"
   - .env.example sin .env.local → "faltan variables de entorno locales"
   - .next/ más viejo que el último commit → "build cache viejo"
   - requirements.txt sin venv → "instalar deps de Python"
5. Presenta el resumen con ESTE formato:

**Proyecto:** [nombre]
**Última sesión:** [fecha del STATE.md, o "primera sesión"]
**Cambios externos traídos:** [solo si hubo pull]
**Lo hecho:** [2-3 bullets de la última sesión]
**Pendientes:** 🔴 P0 / 🟡 P1 / 🟢 P2
**Próximo paso:** [frase exacta del campo "Próximo paso para retomar"]
**⚠️ Antes de empezar:** [solo si el health check detectó algo]
**¿Por dónde empezamos?**

6. Si no existe STATE.md (carpeta nueva o carpeta sin bitácora) → Paso 3.

## Paso 3 — Protocolo de proyecto nuevo
Cada proyecto es una carpeta propia con su propio repo: nunca dentro de otro repo ni
dentro del hub desde el que arranca Claude. Haz UNA pregunta y de la respuesta infiere
todo lo demás (adapta rutas, cuentas y stack a los del usuario):

  ¿Qué estamos construyendo?
  1. Landing de cliente      → ~/Clientes/[cliente]/[nombre] · org de la empresa · Next.js · Supabase · Vercel
  2. Landing o embudo propio → ~/proyectos/[nombre] · cuenta personal · Next.js · Supabase · Vercel
  3. SaaS o app propia       → ~/proyectos/[nombre] · cuenta personal · Next.js · Supabase · Vercel
  4. Dashboard interno       → ~/proyectos/[nombre] · cuenta personal · Next.js + Supabase · acceso con contraseña
  5. Script o herramienta    → ~/proyectos/[nombre] · cuenta personal · sin DB · sin deploy
  6. Otro                    → pregunta solo lo que no puedas inferir

Si es de cliente, pide además el nombre del cliente para la carpeta. Si no queda claro
en qué cuenta de GitHub va (personal o empresa), esa es la única pregunta extra.

Con la respuesta, sin más preguntas:
1. Crea la carpeta en la ruta que corresponde al tipo.
2. `git init`.
3. Repo privado en GitHub: `gh repo create <cuenta>/<nombre> --private`.
4. `git remote add origin ...`.
5. Escribe STATE.md con este contenido:

   # [nombre-proyecto]
   **Tipo:** [tipo]  **Stack:** [stack]  **Repo:** [URL]  **Deploy:** [Vercel / sin deploy]  **DB:** [Supabase / ninguna]
   ---
   ## Sesión 1 — [fecha]
   **Lo hecho:** - Proyecto creado desde cero
   **Pendientes:** 🔴 P0: definir primer paso real
   **Próximo paso para retomar:** definir estructura inicial

6. Si es de cliente, deja un CLAUDE.md mínimo en la carpeta del cliente (nombre del proyecto y repo).
7. Si existe un STACK.md global (en el hub), anota ahí el proyecto con tipo y stack.
8. `git add . && git commit -m "init: [nombre]" && git push -u origin main`.

Presenta el mismo resumen del Paso 2 con "Primera sesión: [fecha]", la carpeta, el repo
y el stack, y termina con "¿Por dónde empezamos?".
