unit UnitDeclaracoes;

interface

function Bematech_Fiscal_AbrirNota( dados: String ): Pchar ; StdCall; External 'BemaONE32.DLL';
function Bematech_Fiscal_VenderItem( dados: String ): Pchar; StdCall; External 'BemaONE32.DLL';
function Bematech_Fiscal_EfetuarPagamento( dados: String ): Pchar; StdCall; External 'BemaONE32.DLL';
function Bematech_Fiscal_FecharNota( dados: String ): Pchar; StdCall; External 'BemaONE32.DLL';
function Bematech_Fiscal_EstornarNota( ): Pchar; StdCall; External 'BemaONE32.DLL';
function Bematech_Fiscal_ObterStatusImpressora( ): Pchar; StdCall; External 'BemaONE32.DLL';
function Bematech_Fiscal_ObterInformacoesSistema( ): Pchar; StdCall; External 'BemaONE32.DLL';
function Bematech_Fiscal_CancelarNota( dados: String ): Pchar; StdCall; External 'BemaONE32.DLL';
function Bematech_Fiscal_ConsultarNota( dados: String ): Pchar; StdCall; External 'BemaONE32.DLL';
function Bematech_Fiscal_ImprimirTextoLivre( dados: String ): Pchar; StdCall; External 'BemaONE32.DLL';

implementation

end.
