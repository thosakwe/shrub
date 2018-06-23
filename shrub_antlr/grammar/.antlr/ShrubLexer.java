// Generated from /Users/thosakwe/Source/Compilers/shrub/shrub_antlr/grammar/ShrubLexer.g4 by ANTLR 4.7.1
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class ShrubLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		Normal=1, WS=2, SINGLE_COMMENT=3, ARROW=4, COMMA=5, LBRACKET=6, RBRACKET=7, 
		LCURLY=8, RCURLY=9, LPAREN=10, RPAREN=11, FN=12, IMPORT=13, WITH=14, HEX=15, 
		NUMBER=16, STRING=17, ID=18, INTERPOLATION=19, END=20;
	public static final int
		NORMAL=1, TEMPLATE_STRING=2;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE", "NORMAL", "TEMPLATE_STRING"
	};

	public static final String[] ruleNames = {
		"Normal", "WS", "SINGLE_COMMENT", "ARROW", "COMMA", "LBRACKET", "RBRACKET", 
		"LCURLY", "RCURLY", "LPAREN", "RPAREN", "FN", "IMPORT", "WITH", "HEX", 
		"NUMBER", "STRING", "ID", "INTERPOLATION", "END"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, null, null, "'=>'", "','", "'['", "']'", "'{'", "'}'", "'('", 
		"')'", "'fn'", "'import'", "'with'", null, null, null, null, "'%{'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, "Normal", "WS", "SINGLE_COMMENT", "ARROW", "COMMA", "LBRACKET", 
		"RBRACKET", "LCURLY", "RCURLY", "LPAREN", "RPAREN", "FN", "IMPORT", "WITH", 
		"HEX", "NUMBER", "STRING", "ID", "INTERPOLATION", "END"
	};
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}


	public ShrubLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "ShrubLexer.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\26\u0088\b\1\b\1"+
		"\b\1\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4"+
		"\n\t\n\4\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t"+
		"\21\4\22\t\22\4\23\t\23\4\24\t\24\4\25\t\25\3\2\3\2\3\2\3\2\3\3\6\3\63"+
		"\n\3\r\3\16\3\64\3\3\3\3\3\4\3\4\3\4\3\4\6\4=\n\4\r\4\16\4>\3\5\3\5\3"+
		"\5\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\f\3\f\3\r\3\r\3"+
		"\r\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\20\3"+
		"\20\3\20\3\20\6\20e\n\20\r\20\16\20f\3\21\5\21j\n\21\3\21\6\21m\n\21\r"+
		"\21\16\21n\3\21\3\21\6\21s\n\21\r\21\16\21t\5\21w\n\21\3\22\3\22\3\22"+
		"\3\22\3\23\3\23\3\23\3\24\3\24\3\24\3\24\3\24\3\25\3\25\3\25\3\25\2\2"+
		"\26\5\3\7\4\t\5\13\6\r\7\17\b\21\t\23\n\25\13\27\f\31\r\33\16\35\17\37"+
		"\20!\21#\22%\23\'\24)\25+\26\5\2\3\4\b\5\2\13\f\17\17\"\"\3\2\f\f\5\2"+
		"\62;CHch\3\2\62;\5\2C\\aac|\6\2\62;C\\aac|\2\u008c\2\5\3\2\2\2\3\7\3\2"+
		"\2\2\3\t\3\2\2\2\3\13\3\2\2\2\3\r\3\2\2\2\3\17\3\2\2\2\3\21\3\2\2\2\3"+
		"\23\3\2\2\2\3\25\3\2\2\2\3\27\3\2\2\2\3\31\3\2\2\2\3\33\3\2\2\2\3\35\3"+
		"\2\2\2\3\37\3\2\2\2\3!\3\2\2\2\3#\3\2\2\2\3%\3\2\2\2\3\'\3\2\2\2\4)\3"+
		"\2\2\2\4+\3\2\2\2\5-\3\2\2\2\7\62\3\2\2\2\t8\3\2\2\2\13@\3\2\2\2\rC\3"+
		"\2\2\2\17E\3\2\2\2\21G\3\2\2\2\23I\3\2\2\2\25K\3\2\2\2\27M\3\2\2\2\31"+
		"O\3\2\2\2\33Q\3\2\2\2\35T\3\2\2\2\37[\3\2\2\2!`\3\2\2\2#i\3\2\2\2%x\3"+
		"\2\2\2\'|\3\2\2\2)\177\3\2\2\2+\u0084\3\2\2\2-.\13\2\2\2./\3\2\2\2/\60"+
		"\b\2\2\2\60\6\3\2\2\2\61\63\t\2\2\2\62\61\3\2\2\2\63\64\3\2\2\2\64\62"+
		"\3\2\2\2\64\65\3\2\2\2\65\66\3\2\2\2\66\67\b\3\3\2\67\b\3\2\2\289\7\61"+
		"\2\29:\7\61\2\2:<\3\2\2\2;=\n\3\2\2<;\3\2\2\2=>\3\2\2\2><\3\2\2\2>?\3"+
		"\2\2\2?\n\3\2\2\2@A\7?\2\2AB\7@\2\2B\f\3\2\2\2CD\7.\2\2D\16\3\2\2\2EF"+
		"\7]\2\2F\20\3\2\2\2GH\7_\2\2H\22\3\2\2\2IJ\7}\2\2J\24\3\2\2\2KL\7\177"+
		"\2\2L\26\3\2\2\2MN\7*\2\2N\30\3\2\2\2OP\7+\2\2P\32\3\2\2\2QR\7h\2\2RS"+
		"\7p\2\2S\34\3\2\2\2TU\7k\2\2UV\7o\2\2VW\7r\2\2WX\7q\2\2XY\7t\2\2YZ\7v"+
		"\2\2Z\36\3\2\2\2[\\\7y\2\2\\]\7k\2\2]^\7v\2\2^_\7j\2\2_ \3\2\2\2`a\7\62"+
		"\2\2ab\7z\2\2bd\3\2\2\2ce\t\4\2\2dc\3\2\2\2ef\3\2\2\2fd\3\2\2\2fg\3\2"+
		"\2\2g\"\3\2\2\2hj\7/\2\2ih\3\2\2\2ij\3\2\2\2jl\3\2\2\2km\t\5\2\2lk\3\2"+
		"\2\2mn\3\2\2\2nl\3\2\2\2no\3\2\2\2ov\3\2\2\2pr\7\60\2\2qs\t\5\2\2rq\3"+
		"\2\2\2st\3\2\2\2tr\3\2\2\2tu\3\2\2\2uw\3\2\2\2vp\3\2\2\2vw\3\2\2\2w$\3"+
		"\2\2\2xy\7b\2\2yz\3\2\2\2z{\b\22\4\2{&\3\2\2\2|}\t\6\2\2}~\t\7\2\2~(\3"+
		"\2\2\2\177\u0080\7\'\2\2\u0080\u0081\7}\2\2\u0081\u0082\3\2\2\2\u0082"+
		"\u0083\b\24\2\2\u0083*\3\2\2\2\u0084\u0085\7b\2\2\u0085\u0086\3\2\2\2"+
		"\u0086\u0087\b\25\5\2\u0087,\3\2\2\2\f\2\3\4\64>fintv\6\7\3\2\b\2\2\7"+
		"\4\2\6\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}