# FPGA razvojno okolje

Skripta `fpga` poenostavi delo z **Anvilom** za ploščo **Nexys A7-50T**. Anvil teče v Dockerju, bitstream pa naložimo iz macOS-a z `openFPGALoader`.

## Ukazi

| Ukaz                                             | Opis                                                            |
| ------------------------------------------------ | --------------------------------------------------------------- |
| `fpga init`                                      | Inicializira nov projekt v trenutni prazni mapi.                |
| `fpga init ime_projekta`                         | Ustvari mapo in inicializira projekt.                           |
| `fpga init ime_projekta --example switches-leds` | Ustvari projekt s primerom `switches-leds`.                     |
| `fpga build`                                     | Prevede projekt v Dockerju in shrani `top.bit` v trenutno mapo. |
| `fpga flash`                                     | Naloži `top.bit` na FPGA z `openFPGALoader`.                    |
| `fpga run`                                       | Izvede `build` in nato `flash`.                                 |
| `fpga shell`                                     | Odpre interaktivni terminal v Docker okolju Anvil.              |
| `fpga help`                                      | Izpiše pomoč.                                                   |

## Primer uporabe

```bash
cd ~/Documents/faks/dn

fpga init vaje0X --example switches-leds
cd vaje0X

fpga run
```

## Opombe

- Ukazi uporabljajo trenutno mapo (`PWD`) kot mapo projekta.
- `fpga build` prevaja na hitrem Linuxovem datotečnem sistemu, da se izogne počasnemu Docker bind mountu.
- Končni bitstream je shranjen kot `top.bit` v mapi projekta.
- Potrebni so Docker Desktop, slika `jurevreca12/anvil-docker:0.2` in `openFPGALoader` na Macu.
- Za hitro prevajanje uporabljaj `fpga build`, ne `anvil synth` znotraj `fpga shell`.
