import org.antlr.v4.runtime.*;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.err.println("Usage: java Main <file.js>");
            System.exit(1);
        }
        CharStream input = CharStreams.fromPath(Paths.get(args[0]));
        JSLexer lexer = new JSLexer(input);
        lexer.removeErrorListeners();
        List<String> errors = new ArrayList<>();
        System.out.println("--- Tokens Found ---");
        for (Token t = lexer.nextToken(); t.getType() != Token.EOF; t = lexer.nextToken()) {
            int line = t.getLine();
            int col = t.getCharPositionInLine() + 1;
            if (t.getType() == JSLexer.ERROR_CHAR) {
                errors.add("Error at " + line + ":" + col
                        + " Invalid or unexpected token '" + escape(t.getText()) + "'");
            } else {
                String type = JSLexer.VOCABULARY.getSymbolicName(t.getType());
                System.out.println("<" + type + "> [" + escape(t.getText()) + "] ("
                        + line + ":" + col + ")");
            }
        }
        System.out.println("--- Lexical Errors: " + errors.size() + " ---");
        for (String error : errors) {
            System.out.println(error);
        }
    }

    private static String escape(String s) {
        return s.replace("\\", "\\\\")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
