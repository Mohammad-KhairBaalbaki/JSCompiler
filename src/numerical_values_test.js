
// ============================================================
// SECTION 3: NUMERIC LITERALS
// JavaScript ECMAScript 2025
// Reference: MDN - JavaScript Lexical Grammar
// Required: INTEGER, FLOAT, HEX_NUMBER, OCTAL_NUMBER, BIGINT
// ============================================================


// ============================================================
// 1. DECIMAL INTEGER LITERALS
// ============================================================

// Test 1: Basic decimal integers
0;
1;
2;
9;
10;
42;
100;
999;
123456789;

// Test 2: Large decimal integers
1000000;
1234567890123456789;
9007199254740991;

// Test 3: Zero
0;


// ============================================================
// 2. FLOATING-POINT LITERALS
// ============================================================

// Test 4: Standard floating-point numbers
0.0;
1.0;
3.14;
10.25;
99.99;

// Test 5: Fraction without integer part
.5;
.25;
.123456;

// Test 6: Decimal point without fraction
5.;
10.;
100.;

// Test 7: Very small and large decimal values
0.000001;
123456.789;
999999.999;


// ============================================================
// 3. EXPONENTIAL NOTATION
// ============================================================

// Test 8: Positive exponents
1e3;
2e5;
5E2;
10e4;

// Test 9: Negative exponents
1e-3;
2E-5;
5.5e-2;

// Test 10: Explicit positive exponent sign
1e+3;
2E+5;
3.14e+2;

// Test 11: Exponent with decimal base
1.5e3;
2.75E4;
.5e2;
5.e2;


// ============================================================
// 4. HEXADECIMAL NUMBERS
// ============================================================

// Test 12: Basic hexadecimal numbers
0x0;
0x1;
0x9;
0xA;
0xF;

// Test 13: Uppercase and lowercase hexadecimal digits
0xFF;
0xff;
0xAbCd;
0XCAFE;
0X123ABC;

// Test 14: Longer hexadecimal values
0x12345678;
0xFFFFFFFF;
0xabcdef123456;


// ============================================================
// 5. OCTAL NUMBERS
// ============================================================

// Test 15: Basic octal numbers
0o0;
0o1;
0o7;
0o10;
0o17;
0o77;

// Test 16: Uppercase prefix
0O10;
0O755;
0O123;

// Test 17: Longer octal numbers
0o1234567;
0o777777;


// ============================================================
// 6. BINARY NUMBERS
// Additional JavaScript numeric form supported by MDN
// ============================================================

// Test 18: Basic binary numbers
0b0;
0b1;
0b10;
0b11;

// Test 19: Longer binary numbers
0b1010;
0b11111111;
0b1000000000000000;

// Test 20: Uppercase prefix
0B0;
0B1;
0B1010;
0B11111111;


// ============================================================
// 7. BIGINT LITERALS
// ============================================================

// Test 21: Decimal BigInt
0n;
1n;
2n;
10n;
123n;
999999999999999999n;

// Test 22: Hexadecimal BigInt
0x0n;
0x1n;
0xFFn;
0xabcdefn;
0XCAFE n;

// Test 23: Octal BigInt
0o0n;
0o7n;
0o10n;
0o755n;
0O123n;

// Test 24: Binary BigInt
0b0n;
0b1n;
0b101n;
0b11111111n;


// ============================================================
// 8. NUMERIC SEPARATORS
// Underscores between digits
// ============================================================

// Test 25: Decimal integer separators
1_000;
10_000;
1_000_000;
123_456_789;

// Test 26: Floating-point separators
1_000.5;
12_345.678;
1.234_567;

// Test 27: Exponential notation with separators
1_000e2;
1.5e1_0;
2_500E+3;

// Test 28: Hexadecimal separators
0xFF_FF;
0xA0_B0_C0;
0x12_34_AB;

// Test 29: Octal separators
0o7_5_5;
0o12_34;

// Test 30: Binary separators
0b1010_0101;
0b1111_0000;

// Test 31: BigInt separators
1_000n;
123_456_789n;
0xFF_FFn;
0o77_55n;
0b1010_0101n;


// ============================================================
// 9. LEGACY LEADING-ZERO NUMBERS
// Special JavaScript syntax
// ============================================================

// Test 32: Legacy octal notation
0777;
0123;
0001;

// Test 33: Leading-zero decimal notation
0888;
09;


// ============================================================
// 10. SIGNS ARE OPERATORS, NOT PART OF NUMERIC LITERALS
// ============================================================

// Test 34: Unary minus
-25;
-3.14;
-1e3;

// Test 35: Unary plus
+18;
+0.25;
+2e5;

// Test 36: Signed non-decimal values
-0xFF;
+0o77;
-0b1010;

// Test 37: BigInt with unary operators
-100n;
+200n;


// ============================================================
// 11. INVALID NUMERIC LITERALS
// Lexical errors are expected in this section
// ============================================================

// Test 38: Invalid hexadecimal numbers
0x;
0xG;
0xZZ;
0x1G;

// Test 39: Invalid octal numbers
0o;
0o8;
0o9;
0o89;

// Test 40: Invalid binary numbers
0b;
0b2;
0b102;
0b1201;

// Test 41: Invalid exponent notation
1e;
1E;
1e+;
1e-;
2.5e+;

// Test 42: Invalid decimal formats
1.2.3;
12abc;
123xyz;

// Test 43: Invalid numeric separators
1_;
1__2;
_100;
0_1;
1._5;
1e_5;
1n_;

// Test 44: Invalid BigInt formats
0755n;
1.5n;
3.14n;
1e3n;
0xFF.5n;

// Test 45: Invalid combinations
123n.5;
0b102n;
0o89n;
0xG12n;


// ============================================================
// END OF SECTION 3
// ============================================================
