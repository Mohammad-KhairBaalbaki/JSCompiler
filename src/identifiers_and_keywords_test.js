
// SECTION 2: IDENTIFIERS & KEYWORDS


//  ------ BASIC IDENTIFIERS ---

// Test 1: Simple identifiers
name;
age;
student;
counter;
result;

// Test 2: Identifiers with uppercase and lowercase letters
myVariable;
MyVariable;
MYVARIABLE;
camelCase;
PascalCase;

// Test 3: Identifiers containing numbers
value1;
value123;
student2025;
version2;

// Test 4: Identifiers starting with underscore or dollar sign
_private;
__internal;
$price;
$$value;
$_name;
_$value;


// -----IDENTIFIER BOUNDARIES

// Test 5: Similar names must remain separate identifiers
variable;
variables;
varValue;
letValue;
constValue;
trueValue;
falseValue;
nullValue;
returnValue;
className;

// Test 6: Case sensitivity
name;
Name;
NAME;
student;
Student;
STUDENT;


// ------ NICODE IDENTIFIERS ----

// Test 7: Identifiers using non-ASCII letters
café;
naïve;
über;
π;
Δ;
你好;
مرحبا;
学生;

// Test 8: Unicode characters in different positions
user名;
名user;
café2025;
π_value;

// Test 9: Unicode combining marks
á;
évalue;

// Test 10: Zero Width Non-Joiner (U+200C): The identifier below contains an invisible ZWNJ character:
user‌name;

// Test 11: Zero Width Joiner (U+200D): he identifier below contains an invisible ZWJ character:
user‍name;


// -------. UNICODE ESCAPE SEQUENCES IN IDENTIFIERS


// Test 12: Four-digit Unicode escape
var \u0061 = 10;

// Test 13: Multiple Unicode escapes
var \u006D\u0079Variable = 20;

// Test 14: Unicode code point escape
var \u{61} = 30;

// Test 15: Unicode escape in the middle of an identifier
var user\u004Eame = 40;

// Test 16: Escaped identifier representing a reserved word
// Lexically, this spelling represents "else".
var els\u{65} = 50;


// ---- PRIVATE IDENTIFIERS

// Test 17: Private identifiers
#privateField;
#name;
#value;
#_internal;
#$price;

// Test 18: Private identifiers inside a class
class Example {
    #privateField;
    #counter = 0;

    getValue() {
        return this.#privateField;
    }
}


// --- RESERVED KEYWORDS

// Test 19: Control flow keywords
break;
case;
catch;
continue;
default;
do;
else;
for;
if;
return;
switch;
while;

// Test 20: Declaration and function keywords
class;
const;
function;
let;
var;

// Test 21: Object-oriented keywords
extends;
new;
super;
this;

// Test 22: Exception handling keywords
finally;
throw;
try;

// Test 23: Module-related keywords
export;
import;

// Test 24: Operators written as keywords
delete;
in;
instanceof;
typeof;
void;

// Test 25: Other reserved keywords
debugger;
with;



// ----- CONTEXTUAL KEYWORDS & IDENTIFIERS WITH SPECIAL MEANINGS

// Test 26: Contextual keywords
async;
await;
yield;
of;
from;
as;

// Test 27: Special identifiers that are not reserved keywords
arguments;
eval;
get;
set;

// Test 28: Import-related special names
target;
meta;


// 8. FUTURE RESERVED WORDS

// Test 29: Always reserved future keyword
enum;

// Test 30: Strict-mode future reserved words
implements;
interface;
package;
private;
protected;
public;

// Test 31: Older future reserved words
abstract;
boolean;
byte;
char;
double;
final;
float;
goto;
int;
long;
native;
short;
synchronized;
throws;
transient;
volatile;


// 9. BOOLEAN & NULL LITERALS

// Test 32: Boolean literals
true;
false;

// Test 33: Null literal
null;

// Test 34: Undefined is NOT a reserved keyword
undefined;


// 10. IDENTIFIERS IN REAL JAVASCRIPT CODE

// Test 35: Variable declarations
var firstName;
let lastName;
const studentAge = 21;

// Test 36: Function identifiers
function calculateTotal() {}
function getStudentName() {}

// Test 37: Class identifiers
class Student {}
class UserAccount {}

// Test 38: Object property identifiers
var student = {
    firstName: "Ali",
    lastName: "Ahmad",
    age: 22
};

// Test 39: Identifiers used with keywords
var total = 100;

if (total >= 50) {
    var result = total;
}

// Test 40: Unicode identifiers in declarations
var اسم = "Masa";
var 学生 = "Student";
