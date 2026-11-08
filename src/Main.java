// ============================================================
// Main.java - تشغيل المحلل المفرداتي وطباعة التوكنز
// طريقة التشغيل:
//   1. antlr4 JSLexer.g4
//   2. javac *.java
//   3. java Main input.js
// ============================================================

import org.antlr.v4.runtime.*;
import java.io.*;
import java.util.*;

public class Main {

    public static void main(String[] args) throws Exception {

        // --- قراءة ملف الدخل ---
        String inputFile = args.length > 0 ? args[0] : "input.js";
        CharStream input = CharStreams.fromFileName(inputFile);

        // --- تشغيل الـ Lexer ---
        JSLexer lexer = new JSLexer(input);

        // إزالة الـ error listener الافتراضي وإضافة واحد خاص فينا
        lexer.removeErrorListeners();
        LexerErrorListener errorListener = new LexerErrorListener();
        lexer.addErrorListener(errorListener);

        CommonTokenStream tokens = new CommonTokenStream(lexer);
        tokens.fill();

        // --- طباعة التوكنز ---
        System.out.println("--- Tokens Found ---");

        for (Token token : tokens.getTokens()) {
            // تجاهل EOF
            if (token.getType() == Token.EOF) continue;

            String tokenName = lexer.getVocabulary().getSymbolicName(token.getType());
            String text      = token.getText();
            int    line      = token.getLine();
            int    col       = token.getCharPositionInLine() + 1; // +1 عشان يبدأ من 1

            // طباعة بالصيغة المطلوبة: [النص] Type: النوع  (سطر:عمود)
            System.out.printf("[%-20s] Type: %-25s (%d:%d)%n",
                    text, tokenName, line, col);
        }

        // --- طباعة الأخطاء ---
        List<String> errors = errorListener.getErrors();
        System.out.println("\n--- Lexical Errors: " + errors.size() + " ---");
        for (String err : errors) {
            System.out.println(err);
        }
    }
}

// ============================================================
// LexerErrorListener.java - يلتقط الأخطاء المعجمية
// ============================================================

class LexerErrorListener extends BaseErrorListener {

    private final List<String> errors = new ArrayList<>();

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer,
                            Object offendingSymbol,
                            int line, int charPositionInLine,
                            String msg, RecognitionException e) {

        // صيغة الخطأ: Error at سطر:عمود  الرسالة
        String error = String.format("Error at %d:%d  %s",
                line, charPositionInLine + 1, msg);

        errors.add(error);
    }

    public List<String> getErrors() {
        return errors;
    }
}
