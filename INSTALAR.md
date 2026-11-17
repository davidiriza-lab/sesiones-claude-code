# INSTALAR.md — instrucciones para Claude Code

Este archivo lo lee Claude Code cuando alguien le pide instalar este sistema. Sigue los
pasos en orden. No inventes pasos que no estén aquí. Habla en el idioma del usuario.

Repo: https://github.com/davidiriza-lab/sesiones-claude-code
Guía: https://davidiriza.com/lab/inicio-y-cierre-de-sesion

Todos los archivos se descargan de
`https://raw.githubusercontent.com/davidiriza-lab/sesiones-claude-code/main/<ruta>`.

Si leíste este archivo con una herramienta que resume páginas, bájalo completo antes de seguir,
porque la pregunta del Paso 0 y las plantillas van tal cual:
`curl -fsSL https://raw.githubusercontent.com/davidiriza-lab/sesiones-claude-code/main/INSTALAR.md`

## Reglas para toda la instalación

- **Nunca sobrescribas un archivo que ya existe sin preguntar.** Si existe, muestra en una
  línea qué hay y pregunta: reemplazar, conservar o fusionar. Antes de reemplazar, guarda
  copia como `<archivo>.bak`.
- No pidas tokens, contraseñas ni llaves. Nada de esto los necesita.
- No instales dependencias ni MCPs. Solo archivos y carpetas.
- Cada paso que ejecutes, dilo en una línea. Al final, un resumen de qué quedó hecho.
- Si `gh` no está autenticado (`gh auth status` falla), salta la creación de repos remotos y
  dilo en una línea. Todo lo demás sigue igual.

## Paso 0 — Pregunta qué quiere instalar y espera

Antes de tocar nada, haz exactamente esta pregunta y espera la respuesta:

```
¿Qué quieres instalar?

1. Solo el sistema de sesiones
   /iniciar-sesion y /cerrar-sesion, con STATE.md por proyecto.
   Tus carpetas se quedan donde están.

2. Solo el workspace
   ~/proyectos/ (una carpeta por proyecto), vistas por organización con
   symlinks en ~/Workspace/, y un workspace de VS Code que abre todo en
   una ventana.

3. Todo, al estilo David Iriza
   Lo de 1 y 2, más el hub (~/Claude_Dashboard con STATE.md, STACK.md y
   .gitignore), un CLAUDE.md global con las reglas del sistema, y acceso
   permanente de Claude a ~/proyectos desde el hub.
```

Si contesta 1 → haz A. Si contesta 2 → haz B. Si contesta 3 → haz A, B y C, en ese orden.

## A — Sistema de sesiones

1. `mkdir -p ~/.claude/commands`
2. Descarga `commands/iniciar-sesion.md` y `commands/cerrar-sesion.md` a `~/.claude/commands/`.
3. Pregunta en qué carpeta viven sus proyectos. Si no es `~/proyectos/`, reemplaza esa ruta en
   `~/.claude/commands/iniciar-sesion.md` por la suya. Si la carpeta que eligió todavía no existe,
   créala (`mkdir -p`): sin ella `/iniciar-sesion` cree que el sistema no está instalado.
4. Verifica que ambos archivos existen y tienen frontmatter (`---` en la primera línea).
5. Dile que los comandos aparecen al reiniciar Claude Code, y que la primera vez que corra
   `/iniciar-sesion` en un proyecto sin STATE.md entra al protocolo de proyecto nuevo.

## B — Workspace

1. Pregunta cómo se llaman sus organizaciones para las vistas. Propón tres por defecto y acepta
   las que diga: `🔵 Personal`, `🟠 Empresa`, `🟣 Clientes`.
2. `mkdir -p ~/proyectos ~/Workspace/<cada vista>`
3. Descarga `workspace/crear-vista.sh` a `~/bin/crear-vista.sh` (crea `~/bin` si no existe) y
   dale permiso de ejecución. Si `~/bin` no está en su PATH, dilo y muestra la línea para
   agregarlo a su `.zshrc` o `.bashrc`; no la agregues tú.
4. Descarga `workspace/ejemplo.code-workspace` a `~/workspace.code-workspace` y edita la lista
   `folders` para que tenga:
   - primero `{ "name": "⚡ Hub", "path": "Claude_Dashboard" }` **solo si** existe
     `~/Claude_Dashboard` o se va a crear en el paso C; si no, quítalo;
   - después una entrada por vista, con `path` `Workspace/<vista>`.
5. Si ya tiene carpetas de proyectos en otro lugar, NO las muevas. Pregunta si quiere que las
   enlaces a una vista, y por cada una que diga corre
   `~/bin/crear-vista.sh "<vista>" "<ruta real>" "<nombre en la vista>"`.
6. Dile cómo abrirlo: en VS Code, File → Open Workspace from File → `~/workspace.code-workspace`.

## C — Hub, CLAUDE.md global y acceso permanente

1. **Hub.** `mkdir -p ~/Claude_Dashboard` y dentro:
   - `git init -b main` si no es repo.
   - Descarga `hub/STACK.md` como `STACK.md` y `hub/gitignore.ejemplo` como `.gitignore`
     (regla de no sobrescribir).
   - Crea `STATE.md` con este contenido, poniendo la fecha de hoy:

     ```
     # STATE.md — Hub

     > Bookmark técnico de continuidad. Léelo al inicio de cada sesión y actualízalo al cierre.

     ---

     ## Última sesión — AAAA-MM-DD — Instalación del sistema

     **Hub creado con el instalador de sesiones-claude-code.**

     ### Lo hecho hoy
     - Hub, comandos de sesión y workspace instalados.

     ### Pendientes — orden de prioridad

     #### 🟡 P1 — Esta semana
     - Crear el primer proyecto con /iniciar-sesion [nombre].

     ### Próximo paso para retomar
     Abrir VS Code con ~/workspace.code-workspace y correr /iniciar-sesion.

     ---
     ```
   - Si `gh` está autenticado, pregunta si quiere el hub como repo privado en GitHub y en qué
     cuenta. Si dice que sí: `gh repo create <cuenta>/claude-dashboard --private --source=. --remote=origin`,
     luego `git add -A && git commit -m "init: hub" && git push -u origin main`.
     Si dice que no, solo el commit local.

2. **CLAUDE.md global.** Descarga `hub/CLAUDE.md` a `~/.claude/CLAUDE.md`. Si ya existe uno,
   no lo reemplaces: pregunta si quiere que **agregues** el contenido al final del suyo, y
   hazlo separado por una línea `---`. Sustituye `[tu nombre]` por su nombre si lo dijo; si no,
   déjalo.

3. **Acceso permanente.** En `~/.claude/settings.json` agrega a `permissions.additionalDirectories`
   estas rutas, sin duplicar las que ya estén y sin tocar ninguna otra clave:
   `~/proyectos`, `~/Claude_Dashboard`, `~/Workspace`, `~/.claude/commands`.
   - Si el archivo no existe, créalo con solo esa clave.
   - Si existe, guarda `settings.json.bak`, lee el JSON, fusiona y escribe. Valida que el
     resultado siga siendo JSON válido antes de dar el paso por hecho.
   - Usa rutas absolutas (expande `~` a su home).

4. Asegúrate de que `~/workspace.code-workspace` tiene el hub como primera carpeta (paso B.4).

## Cierre

Imprime un resumen con este formato y termina:

```
Instalado:
- [lista de lo que quedó hecho, un archivo o carpeta por línea]

Saltado o pendiente:
- [lo que no se hizo y por qué, si aplica]

Siguiente paso:
1. Reinicia Claude Code para que aparezcan los comandos.
2. Abre VS Code → File → Open Workspace from File → ~/workspace.code-workspace   (si instalaste el workspace)
3. Corre /iniciar-sesion [nombre-de-tu-primer-proyecto].
```

No ofrezcas nada más. No cierres la sesión ni escribas en ningún STATE.md que no sea el del
hub recién creado.
