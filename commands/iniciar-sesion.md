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

6. Si no existe STATE.md, créalo con el encabezado y una "Sesión 1" vacía,
   y pregunta qué estamos construyendo.
