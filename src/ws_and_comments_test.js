#!/usr/bin/env node

// ==================================================
// SECTION 1: WHITESPACE
// ==================================================

// Test 1: Normal spaces
const spaceTest = 10;

// Test 2: Multiple spaces between tokens
const    multipleSpaces    =    20;

// Test 3: Tabs between tokens
const	tabTest	=	30;

// Test 4: Mixed spaces and tabs
const 	 mixedWhitespace 	 = 	 40;

// Test 5: No-break space (U+00A0)
// يوجد NBSP بين const و nbSpaceTest في السطر التالي:
const nbSpaceTest = 50;

// ==================================================
// SECTION 2: LINE TERMINATORS
// ==================================================

// Test 6: LF line terminator
const lineOne = 1;
const lineTwo = 2;

// Test 7: Multiple empty lines


const afterEmptyLines = 3;


// Test 8: CRLF
// احفظي الملف بنمط CRLF إذا أردت اختبار هذا النوع تحديداً.

// Test 9: Line terminator after comment
const beforeComment = 4; // comment ends here
const afterComment = 5;

// ==================================================
// SECTION 3: SINGLE-LINE COMMENTS
// ==================================================

// Test 10: Basic single-line comment
// This is a single-line comment

// Test 11: Comment after code
const singleLineAfterCode = 60; // This comment should end at this line

// Test 12: Multiple consecutive single-line comments
// First comment
// Second comment
// Third comment

// Test 13: Special characters inside comments
// ! @ # $ % ^ & * ( ) - + =

// Test 14: Comment containing comment-like symbols
// /* This is NOT a block comment */

// ==================================================
// SECTION 4: MULTI-LINE COMMENTS
// ==================================================

// Test 15: Basic multi-line comment
/*
This is a multi-line comment.
It spans multiple lines.
*/

// Test 16: Single-line block comment
/* This is a single-line block comment */

// Test 17: Block comment between tokens
const blockCommentTest /* comment */ = 70;

// Test 18: Block comment between expressions
const calculation = 10 /* middle comment */ + 20;

// Test 19: Multiple consecutive block comments
/* First block comment */
/* Second block comment */
/* Third block comment */

// Test 20: Block comment containing special symbols
/*
! @ # $ % ^ & * ( ) - + =
*/

// Test 21: Block comment containing line comment symbols
/*
This is not a // single-line comment.
*/

// ==================================================
// SECTION 5: MIXED COMMENT AND WHITESPACE CASES
// ==================================================

// Test 22: Comments with tabs and spaces
const mixedOne	=	80; /* block comment */ const mixedTwo = 90;

// Test 23: Single-line comment followed by code on next line
// This comment should not consume the next line
const afterSingleLine = 100;

// Test 24: Multi-line comment followed by code
/*
Comment starts here.
Comment ends here.
*/
const afterMultiLine = 110;

// Test 25: Comments containing code-like text
/*
const fakeVariable = 999;
function fakeFunction() {
    return 123;
}
*/

// Test 26: Empty block comment
/**/

// Test 27: Empty single-line comment
//

// ==================================================
// END OF SECTION 1 TESTS
// ==================================================

const finalTest = 120;
