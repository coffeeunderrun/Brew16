# Brew16

Brew16 is a 16-bit, real mode hobby operating system written in Pascal and Assembly.

> [!NOTE]
> While the goal is to use Pascal, many functions will be written in Assembly conserve space.

## Dependencies

`fpc i8086 cross-compiler`
`open-watcom-v2`
`nasm`

`make`
`git`
`qemu`

`coreutils`
`mtools`
(build FDA image)

## Build

```bash
make
```

## Run

```bash
make run
```

## Clean

```bash
make clean
```

## License

MIT License.
See [LICENSE](LICENSE) file.
