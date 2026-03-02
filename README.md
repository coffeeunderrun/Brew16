# Brew16

Brew16 is a 16-bit, real mode hobby operating system written in Pascal.

## Dependencies

`fpc i8086 cross-compiler`

`nasm`

`gcc`
(linker)

`make`
`git`
`qemu`

`coreutils`
`mtools`
(build FDA image)

## Build

> Override `DEBUG=0` to perform a release build.

```bash
make
```

## Run

> Override `USEGDB=1` to use GDB debugger with QEMU.

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
