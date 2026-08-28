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

## Licencia

MIT — úsalo, adáptalo y compártelo.
