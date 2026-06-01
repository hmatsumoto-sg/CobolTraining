#
PROJECT := UPDATEDB
PROGRAM := $(PROJECT)

COPYLIBDIR := ../../copylib
FETCHDB_DIR := ../fetchdb
PSQL_OPTIONS :=

$(PROGRAM): $(PROGRAM).COB
	cobc -x --save-temps -I$(COPYLIBDIR) -I$(FETCHDB_DIR) -Q "-Wl,--no-as-needed" -locsql -o $@ $<

$(PROGRAM).COB: $(PROGRAM).CBL $(FETCHDB_DIR)/SALESDATA.cpy
	esqlOC -Q -I $(COPYLIBDIR) -I $(FETCHDB_DIR) -o $@ $<

.PHONY: run
run: $(PROGRAM)
	./$(PROGRAM)

.PHONY: clean
clean:
	@rm -rf $(PROGRAM) $(PROGRAM).COB
