# Inicio y cierre de sesión para Claude Code

Dos slash-commands y un archivo (`STATE.md`) para que Claude Code retome cualquier proyecto donde lo dejaste, sin arrastrar el contexto de ayer.

- `/iniciar-sesion [proyecto]` lee `STATE.md`, lo cruza con git, corre un health check y te presenta el estado en un resumen fijo.
- `/cerrar-sesion` escribe la sesión de hoy al inicio de `STATE.md`, hace commit, sube el repo y te manda a `/clear`.

Guía completa, con el porqué medido y el formato del archivo:
**https://davidiriza.com/lab/inicio-y-cierre-de-sesion**

## Instalación

```bash
mkdir -p ~/.claude/commands
curl -fsSL https://raw.githubusercontent.com/davidiriza-lab/sesiones-claude-code/main/commands/iniciar-sesion.md -o ~/.claude/commands/iniciar-sesion.md
curl -fsSL https://raw.githubusercontent.com/davidiriza-lab/sesiones-claude-code/main/commands/cerrar-sesion.md -o ~/.claude/commands/cerrar-sesion.md
```

Los comandos asumen que tus proyectos viven en `~/proyectos/`. Cambia esa ruta en `iniciar-sesion.md` si usas otra.

## Cómo se ordena el disco

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

Lo que hay en este repo para eso:

| Archivo | Qué es |
|---|---|
| `workspace/crear-vista.sh` | Crea (o repara) el symlink de un proyecto en una vista. `--limpiar` borra enlaces rotos. |
| `workspace/ejemplo.code-workspace` | Workspace multi-raíz de VS Code: hub + vistas en una ventana, con `files.exclude` para todas. |
| `hub/STACK.md` | Plantilla del registro global de lo instalado y conectado. |
| `hub/gitignore.ejemplo` | `.gitignore` del hub: fuera secretos, exports y material pesado. |

```bash
curl -fsSL https://raw.githubusercontent.com/davidiriza-lab/sesiones-claude-code/main/workspace/crear-vista.sh -o ~/bin/crear-vista.sh && chmod +x ~/bin/crear-vista.sh
crear-vista.sh "🟠 Empresa" landing-cliente-x "Landing Cliente X"
```

Una trampa del workspace multi-raíz: el directorio de trabajo de Claude sigue a la carpeta del archivo que tienes abierto en VS Code. Antes de `/cerrar-sesion`, ten abierto un archivo del proyecto correcto o nombra el proyecto al pedir el cierre.

Todo esto está explicado, con el porqué, en la sección "Una carpeta por proyecto" y siguientes de la guía.

## Licencia

MIT — úsalo, adáptalo y compártelo.
