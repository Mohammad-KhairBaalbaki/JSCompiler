// =============================================================================
// strings_template_rgex.js
// JavaScript ECMAScript 2025 Lexer
// Section 4: Strings, Template Literals & Special Cases
// Run valid examples and value assertions: node JSCompiler/src/strings_template_rgex.js
// Run isolated malformed cases and lexer checks: node JSCompiler/tests/strings_templates.cjs
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
let user = {name: "Masa"};
let numbers = [10, 20, 30];

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
// Test 12. Template boundaries: strings, comments, functions, and nesting
// -----------------------------------------------------------------------------

let braceString = `Value: ${"}"} tail`;
let backtickString = `Value: ${"`"} tail`;
let blockComment = `Value: ${1 /* } ${ ` ignored */ + 2} tail`;
let lineComment = `Value: ${1 // } ${ ` ignored
    + 2} tail`;
let functionBody = `Value: ${(() => { return {value: 7}; })().value} tail`;
let nestedObject = `Outer ${{value: `Inner ${2 + 3}`}.value} tail`;
let adjacent = `${1}${2}${3}`;
let dollarText = `$ $$ $name ${4} $`;
let escapedThenReal = `\${name}: ${name}`;

// -----------------------------------------------------------------------------
// Test 13. Regex literals and division inside interpolation
// These are valid JavaScript. The lexer must also handle regex token boundaries.
// -----------------------------------------------------------------------------

let regexClosingBrace = `Match: ${/}/.test("}")} tail`;
let regexOpeningBrace = `Match: ${/{/.test("{")} tail`;
let regexClass = `Match: ${/[{}]/.test("{")} tail`;
let regexBacktick = `Match: ${/`/.test("`")} tail`;
let division = `Value: ${12 / 3 / 2} tail`;

// -----------------------------------------------------------------------------
// Test 14. Valid escapes and literal Unicode line/paragraph separators
// The following two strings contain actual U+2028 and U+2029 characters.
// -----------------------------------------------------------------------------

let literalLineSeparator = "A B";
let literalParagraphSeparator = 'A B';
let escapedCodePoint = "\u{10FFFF}";
let taggedInvalidEscape = String.raw`\xZZ`;

// -----------------------------------------------------------------------------
// Test 15. Execute assertions; a wrong result throws instead of silently passing.
// Malformed sources are tested independently in ../tests/strings_templates.cjs.
// -----------------------------------------------------------------------------
//
//const checks = [
//    ["single quote", single1, "Hello"],
//    ["double quote", double1, "Hello"],
//    ["escaped quote", quote1, "It's a beautiful day"],
//    ["hex escape", escape13, "Hexadecimal escape: A"],
//    ["Unicode escape", escape11, "Unicode: A"],
//    ["code point escape", escape12, "Unicode code point: 😀"],
//    ["identity escape q", escape14, "Unknown escape: q"],
//    ["identity escape z", escape15, "Another unknown escape: z"],
//    ["line continuation", continuation1, "This is the first line and this is the second line"],
//    ["CRLF continuation", continuation3, "CRLF continuation: second line"],
//    ["multiline template", template3, "This is a template literal\nthat spans multiple lines."],
//    ["interpolation", interpolation1, "Hello Masa"],
//    ["object property", interpolation8, "Object property: Masa"],
//    ["array element", interpolation9, "Array element: 10"],
//    ["nested template", nested1, "Outer Inner template"],
//    ["nested interpolation", nested2, "Result: Value = 15"],
//    ["nested template and text", nested3, "Outer text Inner Masa outer text"],
//    ["escaped backtick", templateEscape1, "Escaped backtick: `"],
//    ["escaped interpolation", templateEscape3, "Escaped interpolation: ${name}"],
//    ["object braces", complex3, "Object: Laptop"],
//    ["nested braces", complex5, "Nested braces: 100"],
//    ["quoted interpolation text", complex6, "String inside expression: Hello ${name}"],
//    ["empty template", boundary3, ""],
//    ["brace in string", braceString, "Value: } tail"],
//    ["backtick in string", backtickString, "Value: ` tail"],
//    ["block comment", blockComment, "Value: 3 tail"],
//    ["line comment", lineComment, "Value: 3 tail"],
//    ["function body", functionBody, "Value: 7 tail"],
//    ["template in object", nestedObject, "Outer Inner 5 tail"],
//    ["adjacent substitutions", adjacent, "123"],
//    ["literal dollars", dollarText, "$ $$ $name 4 $"],
//    ["escaped and real substitutions", escapedThenReal, "${name}: Masa"],
//    ["regex closing brace", regexClosingBrace, "Match: true tail"],
//    ["regex opening brace", regexOpeningBrace, "Match: true tail"],
//    ["regex character class", regexClass, "Match: true tail"],
//    ["regex backtick", regexBacktick, "Match: true tail"],
//    ["division", division, "Value: 2 tail"],
//    ["literal U+2028", literalLineSeparator, "A\u2028B"],
//    ["literal U+2029", literalParagraphSeparator, "A\u2029B"],
//    ["maximum code point", escapedCodePoint, String.fromCodePoint(0x10FFFF)],
//    ["tagged invalid escape", taggedInvalidEscape, "\\xZZ"],
//];
//
//for (const [label, actual, expected] of checks) {
//    if (actual !== expected) {
//        throw new Error(`${label}: expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);
//    }
//}
//
//console.log(`PASS: ${checks.length} string/template/regex value assertions`);

let template1 = `Hello, JavaScript!;
