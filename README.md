# Project Blackjack

## Entra a task1 o task2 y corre estos commands

```bash
ca65 src/backgrounds.asm
ca65 src/reset.asm
ca65 src/controllers.asm
ca65 src/actions.asm
ld65 src/reset.o src/backgrounds.o src/actions.o  src/controllers.o -C nes.cfg -o blackjack.nes
```

### Corre el blackjack.nes que resulta de los comandos anteriores en un emulador de NES
