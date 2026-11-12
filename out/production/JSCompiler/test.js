// ===== اختبار شامل لكل أنواع التوكنز =====

// 1. Variable Declarations
var x = 10;
let name = "Ahmad";
const PI = 3.14;

// 2. Numbers - كل الأنواع
var dec     = 42;
var dec2    = 1_000_000;
var float1  = 3.14;
var float2  = .5;
var float3  = 1e10;
var float4  = 1.5e-3;
var hex     = 0xFF;
var hex2    = 0xA0_B0;
var octal   = 0o777;
var binary  = 0b1010;
var big1    = 123n;
var big2    = 0xFFn;

// 3. Strings - الحالات الخاصة
var s1 = "hello world";
var s2 = 'single quotes';
var s3 = "say \"hi\" to him";       // escape داخل double
var s4 = 'it\'s a beautiful day';   // escape داخل single
var s5 = 'it has "double" inside';  // double داخل single بدون escape
var s6 = "it has 'single' inside";  // single داخل double بدون escape
var s7 = "line1\
line2";                              // line continuation
var s8 = "tab:\there  newline:\n";  // escape sequences

// 4. Template Literals
var t1 = `simple template`;
var t2 = `hello ${name}!`;
var t3 = `multi
line
template`;
var t4 = `${1 + 2} result`;

// 5. Booleans & Null
var b1 = true;
var b2 = false;
var n1 = null;

// 6. Operators - كل الأنواع
var a = 5 + 3;
var b = 10 - 2;
var c = 4 * 3;
var d = 8 / 2;
var e = 7 % 3;
var f = 2 ** 10;

// Comparison
var r1 = a == b;
var r2 = a === b;
var r3 = a != b;
var r4 = a !== b;
var r5 = a > b;
var r6 = a < b;
var r7 = a >= b;
var r8 = a <= b;

// Logical
var l1 = true && false;
var l2 = true || false;
var l3 = !true;
var l4 = a ?? b;

// Bitwise
var bw1 = a & b;
var bw2 = a | b;
var bw3 = a ^ b;
var bw4 = ~a;
var bw5 = a << 2;
var bw6 = a >> 2;
var bw7 = a >>> 2;

// Assignment
x += 5;
x -= 3;
x *= 2;
x /= 4;
x %= 3;
x **= 2;
x &&= true;
x ||= false;
x ??= 0;

// Increment / Decrement
x++;
x--;
++x;
--x;

// 7. Control Flow
if (x > 0) {
    console.log("positive");
} else if (x < 0) {
    console.log("negative");
} else {
    console.log("zero");
}

for (let i = 0; i < 10; i++) {
    if (i === 5) break;
    if (i === 3) continue;
}

while (x > 0) {
    x--;
}

do {
    x++;
} while (x < 5);

switch (x) {
    case 1:
        break;
    case 2:
        break;
    default:
        break;
}

// 8. Functions
function greet(name) {
    return "Hello " + name;
}

const add = (a, b) => a + b;

async function fetchData() {
    const result = await fetch("url");
    return result;
}

function* generator() {
    yield 1;
    yield 2;
}

// 9. Classes
class Animal extends Object {
    #privateField = "secret";

    constructor(name) {
        super();
        this.name = name;
    }

    static create() {
        return new Animal("cat");
    }
}

// 10. Error Handling
try {
    throw new Error("oops");
} catch (err) {
    console.log(err);
} finally {
    console.log("done");
}

// 11. Modules
import { something } from 'module';
export default function() {}

// 12. Special Operators
var obj = { a: 1, b: 2 };
var copy = { ...obj };          // spread
var [first, ...rest] = [1,2,3]; // destructuring + rest
var chain = obj?.a;             // optional chaining
var type1 = typeof x;
var type2 = x instanceof Animal;
void 0;
delete obj.a;
var ternary = x > 0 ? "yes" : "no";

// 13. Multi-line comment
/*
    هذا تعليق
    على عدة أسطر
    في JavaScript
*/

// 14. Identifiers - أشكال مختلفة
var _private = 1;
var $element = 2;
var camelCase = 3;
var PascalCase = 4;
var with_underscore = 5;

// ===== خطأ معجمي - للاختبار =====
var error1 = "unterminated string
var error2 = 5;
