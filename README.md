# Project Blackjack

Open the terminal and cd into the project directory and cd to Task1 or Task2

## Task 1

```bash
ca65 src/backgrounds.asm
ca65 src/reset.asm
ld65 src/reset.o src/backgrounds.o -C nes.cfg -o blackjack.nes
```

## Task 2

```bash
cd Task2
ca65 src/backgrounds.asm
ca65 src/reset.asm
ca65 src/controllers.asm
ca65 src/actions.asm
ld65 src/reset.o src/backgrounds.o src/actions.o  src/controllers.o -C nes.cfg -o blackjack.nes
```

### Corre el blackjack.nes que resulta de los comandos anteriores en un emulador de NES
