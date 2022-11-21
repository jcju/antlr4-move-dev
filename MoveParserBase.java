import org.antlr.v4.runtime.*;

public abstract class MoveParserBase extends Parser {
    public MoveParserBase(TokenStream input){
        super(input);
    }

    public boolean next(char expect){
        return _input.LA(1) == expect;
    }
}
