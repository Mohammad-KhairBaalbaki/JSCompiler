// =============================================================================
// section5_test.js
// JavaScript ECMAScript 2025 Lexer
// Section 5: Operators & Punctuators
// =============================================================================


// -----------------------------------------------------------------------------
// 1. Arithmetic Operators
// -----------------------------------------------------------------------------

let a = 10;
let b = 3;

let op1 = a + b;
let op2 = a - b;
let op3 = a * b;
let op4 = a / b;
let op5 = a % b;
let op6 = a ** b;


// -----------------------------------------------------------------------------
// 2. Assignment Operators
// -----------------------------------------------------------------------------

let x = 10;

x += 5;
x -= 2;
x *= 3;
x /= 2;
x %= 4;
x **= 2;

let y = 8;
y <<= 2;
y >>= 1;
y >>>= 1;
y &= 5;
y |= 2;
y ^= 3;

let z = 10;
z &&= true;
z ||= false;
z ??= 20;


// -----------------------------------------------------------------------------
// 3. Comparison Operators
// -----------------------------------------------------------------------------

let c1 = 10 == "10";
let c2 = 10 === 10;
let c3 = 10 != "5";
let c4 = 10 !== "10";

let c5 = 10 > 5;
let c6 = 10 < 20;
let c7 = 10 >= 10;
let c8 = 5 <= 10;


// -----------------------------------------------------------------------------
// 4. Logical Operators
// -----------------------------------------------------------------------------

let logical1 = true && false;
let logical2 = true || false;
let logical3 = !true;

let logical4 = (a > 5) && (b < 10);
let logical5 = (a === 10) || (b === 0);


// -----------------------------------------------------------------------------
// 5. Bitwise Operators
// -----------------------------------------------------------------------------

let bit1 = 5 & 3;
let bit2 = 5 | 3;
let bit3 = 5 ^ 3;
let bit4 = ~5;

let bit5 = 8 << 2;
let bit6 = 16 >> 2;
let bit7 = 16 >>> 2;


// -----------------------------------------------------------------------------
// 6. Increment and Decrement Operators
// -----------------------------------------------------------------------------

let counter = 10;

counter++;
++counter;

counter--;
--counter;

let postIncrement = counter++;
let preIncrement = ++counter;

let postDecrement = counter--;
let preDecrement = --counter;


// -----------------------------------------------------------------------------
// 7. Unary Operators
// -----------------------------------------------------------------------------

let unary1 = +10;
let unary2 = -10;
let unary3 = !false;
let unary4 = ~10;

let unary5 = typeof "JavaScript";
let unary6 = void 0;

let obj = {};
let unary7 = delete obj.property;


// -----------------------------------------------------------------------------
// 8. Conditional (Ternary) Operator
// -----------------------------------------------------------------------------

let age = 20;

let result1 = age >= 18 ? "Adult" : "Minor";
let result2 = age > 25 ? 100 : 50;


// -----------------------------------------------------------------------------
// 9. Nullish Coalescing and Optional Chaining
// -----------------------------------------------------------------------------

let username = null;
let displayName = username ?? "Guest";

let user = {
    name: "Masa",
    address: {
        city: "Damascus"
    }
};

let city = user?.address?.city;
let phone = user?.contact?.phone;

let fallback = user.name ?? "Unknown";


// -----------------------------------------------------------------------------
// 10. Arrow Operator
// -----------------------------------------------------------------------------

let add = (a, b) => a + b;

let square = x => x * x;

let greet = () => "Hello";


// -----------------------------------------------------------------------------
// 11. Spread and Rest Operators
// -----------------------------------------------------------------------------

let numbers = [1, 2, 3];

let copiedNumbers = [...numbers];

function sum(...values) {
    return values.reduce((total, value) => total + value, 0);
}


// -----------------------------------------------------------------------------
// 12. Other Operators
// -----------------------------------------------------------------------------

let value = 10;

let type = typeof value;

let instance = user instanceof Object;

let key = "name" in user;

let result3 = "value" in { value: 100 };


// -----------------------------------------------------------------------------
// 13. Punctuators: Parentheses, Brackets and Braces
// -----------------------------------------------------------------------------

function example(param) {
    let arr = [1, 2, 3];

    let obj = {
        key: param
    };

    return obj.key;
}


// -----------------------------------------------------------------------------
// 14. Punctuators: Separators and Property Access
// -----------------------------------------------------------------------------

let punctuation1 = [10, 20, 30];
let punctuation2 = { name: "Masa", age: 20 };

let property = punctuation2.name;

let arrayElement = punctuation1[0];

let nested = punctuation2?.name;


// -----------------------------------------------------------------------------
// 15. Punctuators: Semicolon, Comma and Colon
// -----------------------------------------------------------------------------

let first = 10, second = 20, third = 30;

let object = {
    first: first,
    second: second,
    third: third
};

let conditional = true ? "Yes" : "No";


// -----------------------------------------------------------------------------
// 16. Punctuators: Ellipsis and Optional Chaining
// -----------------------------------------------------------------------------

let spreadArray = [...numbers];

let config = {
    settings: {
        theme: "dark"
    }
};

let theme = config?.settings?.theme;


// -----------------------------------------------------------------------------
// 17. Operator Precedence and Combination
// -----------------------------------------------------------------------------

let precedence1 = 2 + 3 * 4;
let precedence2 = (2 + 3) * 4;
let precedence3 = 10 > 5 && 20 < 30;
let precedence4 = a + b * 2 >= 15;


// -----------------------------------------------------------------------------
// 18. Adjacent Operators and Longest-Match Cases
// -----------------------------------------------------------------------------

let adjacent1 = a+++b;
let adjacent2 = a---b;

let adjacent3 = a ** b;
let adjacent4 = a **= b;

let adjacent5 = a && b;
let adjacent6 = a ||= b;

let adjacent7 = a ?? b;
let adjacent8 = a ??= b;

let adjacent9 = a?.b;
let adjacent10 = a ? .5 : 0;

let adjacent11 = a >>> b;
let adjacent12 = a >>>= b;

let adjacent13 = a === b;
let adjacent14 = a !== b;


// -----------------------------------------------------------------------------
// 19. All Common Punctuators
// -----------------------------------------------------------------------------

let punctuators = [
        ( ),
        [ ],
        { },
        .,
    ...numbers,
;
,
:
];


// -----------------------------------------------------------------------------
// 20. Invalid / Malformed Operator Cases
// Keep these at the end. Some are invalid JavaScript syntax,
// but they are useful for checking lexical recognition.
// -----------------------------------------------------------------------------

let invalid1 = @;
let invalid2 = #;
let invalid3 = \;