# Temporary, because I lack the extra few minutes to figure out how to
# add this to builder.py

./texts/brandon/2018/sympy.ipynb: ./texts/brandon/2018/sympy.md
	notedown --run $< > OUT
	mv OUT $@
