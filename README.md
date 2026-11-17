# Inicio y cierre de sesión para Claude Code

Retoma cualquier proyecto en un mensaje y deja de pagar por el chat de ayer.

Dos /comandos y un archivo (`STATE.md`) para que Claude Code retome cualquier proyecto donde lo dejaste, sin arrastrar el contexto de ayer. Es para quien trabaja con Claude Code varios días sobre los mismos proyectos; no necesitas saber programar, Claude lo instala.

- `/iniciar-sesion [proyecto]` lee `STATE.md`, lo cruza con git, corre un health check y te presenta el estado en un resumen fijo.
- `/cerrar-sesion` escribe la sesión de hoy al inicio de `STATE.md`, hace commit, sube el repo y te manda a `/clear`.

## Instalar: pega esto en Claude Code

Te pregunta si quieres solo el sistema de sesiones, solo el workspace, o todo al estilo David Iriza, y lo deja instalado.

```
Lee https://raw.githubusercontent.com/davidiriza-lab/sesiones-claude-code/main/INSTALAR.md
y sigue sus instrucciones al pie de la letra. Antes de tocar nada, hazme la pregunta
de qué quiero instalar y espera mi respuesta.
```

Lo que hace cada opción está en [INSTALAR.md](INSTALAR.md). Nunca sobrescribe un archivo tuyo sin preguntar, no pide tokens y no instala dependencias. Al terminar, abre Claude Code de nuevo para que cargue los comandos.

## Qué necesitas

- **Claude Code** en Mac o Linux.
- **git**, que es donde se guarda cada cierre.

Opcional:

- **`gh` (GitHub CLI) con sesión iniciada**, para que cada proyecto nuevo nazca con su repo privado en GitHub. Sin `gh`, todo funciona igual con el repo solo en tu computadora.
- **VS Code**, para abrir el hub y las vistas en una sola ventana (opciones 2 y 3 del instalador).

## Cómo se usa

- `/iniciar-sesion landing-cliente-x` carga ese proyecto y te dice lo hecho, lo pendiente y el próximo paso.
- `/iniciar-sesion` sin nombre lista tus proyectos y pregunta cuál.
- `/iniciar-sesion tienda-nueva` con un nombre que todavía no existe hace una pregunta y crea carpeta, repo y `STATE.md`.
- `/cerrar-sesion` al terminar, y después `/clear`.
- `crear-vista.sh "🟠 Empresa" landing-cliente-x "Landing Cliente X"` agrega un proyecto a una vista.

## Qué trae

| Archivo | Qué es |
|---|---|
| `commands/iniciar-sesion.md` | El comando `/iniciar-sesion`, con el protocolo de proyecto nuevo. |
| `commands/cerrar-sesion.md` | El comando `/cerrar-sesion`. |
| `workspace/crear-vista.sh` | Crea (o repara) el symlink de un proyecto en una vista. `--limpiar` borra enlaces rotos. |
| `workspace/ejemplo.code-workspace` | Workspace multi-raíz de VS Code: hub + vistas en una ventana, con `files.exclude` para todas. |
| `hub/STACK.md` | Plantilla del registro global de lo instalado y conectado. |
| `hub/gitignore.ejemplo` | `.gitignore` del hub: fuera secretos, exports y material pesado. |
| `hub/CLAUDE.md` | CLAUDE.md global con las reglas del sistema (continuidad, git en todo proyecto nuevo, STACK.md, material fuera del código). |
| `INSTALAR.md` | Las instrucciones que sigue Claude cuando le pides instalar todo de cero. |

### Cómo se ordena el disco

El sistema funciona sobre tres carpetas con papeles distintos:

```
~/
├── Claude_Dashboard/   el hub: un repo con contexto (STATE.md propio, STACK.md), sin código de proyectos
├── proyectos/          una carpeta = un repo = un STATE.md
└── Workspace/          vistas por organización, hechas solo de symlinks a ~/proyectos/
```

- **Un proyecto nunca vive dentro del hub ni dentro de otro repo.** `/cerrar-sesion` escribe en el STATE.md del git root; si el proyecto no tiene `.git` propio, la sesión cae en el archivo equivocado. Si `/iniciar-sesion` no encuentra STATE.md, entra en el **protocolo de proyecto nuevo**: una pregunta, y crea carpeta, `git init`, repo privado, STATE.md y primer push.
- **El hub es la carpeta desde la que arranca Claude Code siempre.** La memoria automática se guarda por repositorio, así que arrancar siempre desde la misma carpeta da una sola memoria para todos los proyectos. Con `permissions.additionalDirectories` en `~/.claude/settings.json` Claude puede trabajar cualquier carpeta de `~/proyectos/` sin abrirla aparte.
- **Las vistas son symlinks.** La carpeta real no se mueve; encima hay una capa por organización con nombres cortos. git no las ve.

Todo esto está explicado, con el porqué, en la sección "Una carpeta por proyecto" y siguientes de la guía.

### Instalación a mano (solo los comandos)

```bash
mkdir -p ~/.claude/commands
curl -fsSL https://raw.githubusercontent.com/davidiriza-lab/sesiones-claude-code/main/commands/iniciar-sesion.md -o ~/.claude/commands/iniciar-sesion.md
curl -fsSL https://raw.githubusercontent.com/davidiriza-lab/sesiones-claude-code/main/commands/cerrar-sesion.md -o ~/.claude/commands/cerrar-sesion.md
```

Los comandos asumen que tus proyectos viven en `~/proyectos/`. Cambia esa ruta en `iniciar-sesion.md` si usas otra.

Y el script de las vistas:

```bash
mkdir -p ~/bin
curl -fsSL https://raw.githubusercontent.com/davidiriza-lab/sesiones-claude-code/main/workspace/crear-vista.sh -o ~/bin/crear-vista.sh && chmod +x ~/bin/crear-vista.sh
~/bin/crear-vista.sh "🟠 Empresa" landing-cliente-x "Landing Cliente X"
```

## Si algo falla

- **No aparecen los comandos.** Abre Claude Code de nuevo; los comandos se cargan al arrancar.
- **`/iniciar-sesion` contesta que la conversación ya viene cargada.** Es a propósito: escribe `/clear` y lánzalo otra vez. Si quieres seguir ahí de todos modos, díselo.
- **La sesión se guardó en el `STATE.md` de otra carpeta.** En el workspace multi-raíz de VS Code, el directorio de trabajo de Claude sigue a la carpeta del archivo que tienes abierto. Antes de `/cerrar-sesion`, ten abierto un archivo del proyecto correcto o nombra el proyecto al pedir el cierre.
- **No encuentra mis proyectos.** Los comandos buscan en `~/proyectos/`. Si usas otra carpeta, cámbiala en `~/.claude/commands/iniciar-sesion.md` (el instalador te lo pregunta).
- **El cierre avisó que no pudo subir a GitHub.** No se pierde nada: `STATE.md` quedó guardado en tu computadora. El siguiente `/iniciar-sesion` te recuerda que hay commits sin subir.
- **No tengo `gh` o no he iniciado sesión.** Los proyectos nuevos se quedan con repo solo local. Instala `gh`, corre `gh auth login` y crea el remoto cuando quieras.
- **Mi repo es público o es una plantilla.** `/cerrar-sesion` no sube `STATE.md`: lo deja en `.gitignore` para que tu bitácora no quede a la vista.
- **Una vista apunta a una carpeta que ya no existe.** `~/bin/crear-vista.sh --limpiar` borra los enlaces rotos.

## Guía completa

Con el porqué medido y el formato del archivo: **https://davidiriza.com/lab/inicio-y-cierre-de-sesion**

## Licencia

MIT — úsalo, adáptalo y compártelo.
