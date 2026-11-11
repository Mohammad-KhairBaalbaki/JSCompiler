// =============================================================================
// section4_test.js
// JavaScript ECMAScript 2025 Lexer
// Section 4: Strings, Template Literals & Special Cases
// =============================================================================


// -----------------------------------------------------------------------------
// Test 1. Single-Quoted String Literals
// -----------------------------------------------------------------------------

let single1 = 'Hello';
let single2 = 'JavaScript';
let single3 = 'This is a string with spaces';
let single4 = '12345';
let single5 = '';
let single6 = 'It contains a "double quote" inside';
let single7 = 'Special characters: @#$%^&*()';


// -----------------------------------------------------------------------------
// Test 2. Double-Quoted String Literals
// -----------------------------------------------------------------------------

let double1 = "Hello";
let double2 = "JavaScript";
let double3 = "This is a string with spaces";
let double4 = "12345";
let double5 = "";
let double6 = "It contains a 'single quote' inside";
let double7 = "Special characters: @#$%^&*()";


// -----------------------------------------------------------------------------
// Test 3. Escape Sequences
// -----------------------------------------------------------------------------

let escape1 = 'New line: \n';
let escape2 = "Tab: \t";
let escape3 = "Carriage return: \r";
let escape4 = "Backslash: \\";
let escape5 = "Single quote: \'";
let escape6 = "Double quote: \"";
let escape7 = "Backspace: \b";
let escape8 = "Form feed: \f";
let escape9 = "Vertical tab: \v";
let escape10 = "Null character: \0";
let escape11 = "Unicode: \u0041";
let escape12 = "Unicode code point: \u{1F600}";
let escape13 = "Hexadecimal escape: \x41";
let escape14 = "Unknown escape: \q";
let escape15 = 'Another unknown escape: \z';


// -----------------------------------------------------------------------------
// Test 4. Escaped Quotes and Mixed Quotes
// -----------------------------------------------------------------------------

let quote1 = 'It\'s a beautiful day';
let quote2 = "She said: \"Hello!\"";
let quote3 = 'Double quote " without escaping';
let quote4 = "Single quote ' without escaping";
let quote5 = 'Multiple \' escaped \' quotes';
let quote6 = "Multiple \" escaped \" quotes";


// -----------------------------------------------------------------------------
// Test 5. Line Continuation
// Backslash followed by a line terminator must remain inside one STRING token.
// -----------------------------------------------------------------------------

let continuation1 = "This is the first line \
and this is the second line";

let continuation2 = 'First part \
second part';

let continuation3 = "CRLF continuation: \
second line";


// -----------------------------------------------------------------------------
// Test 6. Multiline Template Literals
// -----------------------------------------------------------------------------

let template1 = `Hello, JavaScript!`;
let template2 = ``;
let template3 = `This is a template literal
that spans multiple lines.`;

let template4 = `First line
Second line
Third line`;

let template5 = `Special characters: @#$%^&*()`;
let template6 = `Single quote: ' and double quote: "`;


// -----------------------------------------------------------------------------
// Test 7. Template Literal Interpolation
// -----------------------------------------------------------------------------

let name = "Masa";
let age = 20;

let interpolation1 = `Hello ${name}`;
let interpolation2 = `Age: ${age}`;
let interpolation3 = `Result: ${10 + 20}`;
let interpolation4 = `Comparison: ${age >= 18}`;
let interpolation5 = `Nested expression: ${Math.max(10, 20)}`;

let interpolation6 = `Multiple values: ${name}, ${age}`;
let interpolation7 = `Calculation: ${10 * (5 + 2)}`;

let interpolation8 = `Object property: ${user.name}`;
let interpolation9 = `Array element: ${numbers[0]}`;

let interpolation10 = `Conditional: ${age >= 18 ? "Adult" : "Minor"}`;


// -----------------------------------------------------------------------------
// Test 8. Nested Template Literals
// -----------------------------------------------------------------------------

let nested1 = `Outer ${`Inner template`}`;

let nested2 = `Result: ${`Value = ${10 + 5}`}`;

let nested3 = `Outer text ${`Inner ${name}`} outer text`;


// -----------------------------------------------------------------------------
// Test 9. Escaped Characters in Template Literals
// -----------------------------------------------------------------------------

let templateEscape1 = `Escaped backtick: \``;
let templateEscape2 = `Escaped dollar sign: \$`;
let templateEscape3 = `Escaped interpolation: \${name}`;
let templateEscape4 = `Backslash: \\`;
let templateEscape5 = `New line: \n`;
let templateEscape6 = `Unicode: \u0041`;
let templateEscape7 = `Code point: \u{1F600}`;


// -----------------------------------------------------------------------------
// Test 10. Template Literals with Complex Expressions
// -----------------------------------------------------------------------------

let complex1 = `Sum: ${10 + 20 + 30}`;

let complex2 = `Array: ${[1, 2, 3].join(", ")}`;

let complex3 = `Object: ${{name: "Laptop", price: 750}.name}`;

let complex4 = `Function: ${(() => 42)()}`;

let complex5 = `Nested braces: ${{outer: {inner: 100}}.outer.inner}`;

let complex6 = `String inside expression: ${"Hello ${name}"}`;


// -----------------------------------------------------------------------------
// Test 11. Empty and Boundary Cases
// -----------------------------------------------------------------------------

let boundary1 = '';
let boundary2 = "";
let boundary3 = ``;

let boundary4 = ' ';
let boundary5 = " ";
let boundary6 = ` `;

let boundary7 = `\n`;
let boundary8 = `\t`;


// -----------------------------------------------------------------------------
// Test 12. Invalid / Malformed String Cases
// These cases are intentionally invalid.
// Keep them at the end of the test file.
// -----------------------------------------------------------------------------

// Unterminated single-quoted string:
let invalid1 = 'This string never ends;

// Unterminated double-quoted string:
let invalid2 = "This string never ends;

// Newline inside a single-quoted string without line continuation:
let invalid3 = 'First line
Second line';

// Newline inside a double-quoted string without line continuation:
let invalid4 = "First line
Second line";

// Backslash at the end of file or before an invalid line continuation:
let invalid5 = "Invalid escape at end \

// Unterminated template literal:
let invalid6 = `This template never ends;

// Unterminated template interpolation:
let invalid7 = `Value: ${name;

// Unterminated nested template:
let invalid8 = `Outer ${`Inner template};

// Unterminated string inside template interpolation:
let invalid9 = `Value: ${"unfinished};

// Unterminated template with multiline content:
let invalid10 = `First line
Second line