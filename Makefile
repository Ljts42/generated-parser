HC=ghc
SOURCES=src\Main.hs src\Grammar.hs
GEN_SOURCES=src\Lexer.x src\Parser.y
GENERATED=src\Lexer.hs src\Parser.hs
PACKAGE=hw0.zip

.PHONY: pack all run clean

all: parser

run: parser
	./parser

clean:
	del src\*.o src\*.hi
	del $(GENERATED)
	del parser.exe

parser: $(GENERATED) $(SOURCES)
	$(HC) -i.\src -tmpdir . .\src\Main.hs -o parser

$(GENERATED): $(GEN_SOURCES) $(SOURCES)
	alex src\Lexer.x -o src\Lexer.hs
	happy src\Parser.y -o src\Parser.hs -i

pack: $(GENERATED)
	7z a -r $(PACKAGE) Makefile src
