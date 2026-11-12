
import org.antlr.v4.runtime.*;
import java.io.*;
import java.util.*;

public class Main {

    public static void main(String[] args) throws Exception {

        String inputFile = args.length > 0 ? args[0] : "input.js";
        CharStream input = CharStreams.fromFileName(inputFile);

        JSLexer lexer = new JSLexer(input);

        lexer.removeErrorListeners();
        LexerErrorListener errorListener = new LexerErrorListener();
        lexer.addErrorListener(errorListener);

        CommonTokenStream tokens = new CommonTokenStream(lexer);
        tokens.fill();

        List<String> errors = new ArrayList<>(errorListener.getErrors());

        System.out.println("--- Tokens Found ---");

        for (Token token : tokens.getTokens()) {
            if (token.getType() == Token.EOF) continue;

            String tokenName = lexer.getVocabulary().getSymbolicName(token.getType());
            String text      = token.getText();
            int    line      = token.getLine();
            int    col       = token.getCharPositionInLine() + 1;

            String errorMessage = switch (token.getType()) {
                case JSLexer.UNTERMINATED_STRING -> "Unterminated string";
                case JSLexer.UNTERMINATED_TEMPLATE -> "Unterminated template literal";
                case JSLexer.UNTERMINATED_COMMENT -> "Unterminated comment";
                case JSLexer.MALFORMED_NUMBER -> "Malformed number";
                case JSLexer.UNKNOWN -> "Unknown character";
                default -> null;
            };
            if (errorMessage != null) {
                String errorText = text.replace("\r", "\\r").replace("\n", "\\n");
                errors.add(String.format("Error at %d:%d  %s: %s",
                        line, col, errorMessage, errorText));
            }

            System.out.printf("[%-20s] Type: %-25s (%d:%d)%n",
                    text, tokenName, line, col);
        }

        System.out.println("\n--- Lexical Errors: " + errors.size() + " ---");
        for (String err : errors) {
            System.out.println(err);
        }
    }
}

class LexerErrorListener extends BaseErrorListener {

    private final List<String> errors = new ArrayList<>();

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer,
                            Object offendingSymbol,
                            int line, int charPositionInLine,
                            String msg, RecognitionException e) {

        String error = String.format("Error at %d:%d  %s",
                line, charPositionInLine + 1, msg);

        errors.add(error);
    }

    public List<String> getErrors() {
        return errors;
    }
}
