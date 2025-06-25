shell:
	swiftc main.swift -o shell -parse-as-library

run: shell
	./shell

clean:
	rm ./shell
