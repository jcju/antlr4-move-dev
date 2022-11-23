import org.antlr.v4.runtime.*;

public abstract class MoveLexerBase extends Lexer{
    public MoveLexerBase(CharStream input){
        super(input);
    }

    Token lt1;
    Token lt2;

    @Override
    public Token nextToken() {
        Token next = super.nextToken();

        if (next.getChannel() == Token.DEFAULT_CHANNEL) {
            // Keep track of the last token on the default channel.
            this.lt2 = this.lt1;
            this.lt1 = next;
        }

        return next;
    }

    public boolean SOF(){
        return _input.LA(-1) <=0;
    }
    
    public boolean next(char expect){
        return _input.LA(1) == expect;
    }

    public boolean floatDotPossible(){
        int next = _input.LA(1);
        // only block . _ identifier after float
        if(next == '.' || next =='_') return false;
        if(next == 'f') {
            // 1.f32
            if (_input.LA(2)=='3'&&_input.LA(3)=='2')return true;
            //1.f64
            if (_input.LA(2)=='6'&&_input.LA(3)=='4')return true;
            return false;
        }
        if(next>='a'&&next<='z') return false;
        if(next>='A'&&next<='Z') return false;
        return true;
    }

    public boolean floatLiteralPossible(){
        if(this.lt1 == null || this.lt2 == null) return true;
        if(this.lt1.getType() != MoveLexer.DOT) return true;
        switch (this.lt2.getType()){
            case MoveLexer.CHAR_LITERAL:
            case MoveLexer.STRING_LITERAL:
            case MoveLexer.RAW_STRING_LITERAL:
            case MoveLexer.BYTE_LITERAL:
            case MoveLexer.BYTE_STRING_LITERAL:
            case MoveLexer.RAW_BYTE_STRING_LITERAL:
            case MoveLexer.INTEGER_LITERAL:
            case MoveLexer.DEC_LITERAL:
            case MoveLexer.HEX_LITERAL:
            case MoveLexer.OCT_LITERAL:
            case MoveLexer.BIN_LITERAL:

            case MoveLexer.KW_SUPER:
            case MoveLexer.KW_SELFVALUE:
            case MoveLexer.KW_SELFTYPE:
            case MoveLexer.KW_CRATE:
            case MoveLexer.KW_DOLLARCRATE:

            case MoveLexer.GT:
            case MoveLexer.RCURLYBRACE:
            case MoveLexer.RSQUAREBRACKET:
            case MoveLexer.RPAREN:

//            case MoveLexer.KW_AWAIT:

            case MoveLexer.NON_KEYWORD_IDENTIFIER:
            case MoveLexer.RAW_IDENTIFIER:
            case MoveLexer.KW_MACRORULES:
                return false;
            default:
                return true;
        }
    }
}
