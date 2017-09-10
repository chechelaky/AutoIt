Este script realiza a subistituição de uma variável aaa por outra bbb, em todos os tipos de do arquivo pré-definido de um diretório e seus subdiretórios.
Obs: o arquivo em questão tem que ser texto puro, como .txt, .css, .html, etc.

Substituição em lote
Pra quem trabalha com GDI+, já se deparou que os velhos scripts que escreveu não abrem na última versão.
A solução é bastante simples, a variável $ghGDIPDll teve seu nome atualizado para $__g_hGDIPDll.
Então é só você pegar o nome antigo e substituir pelo novo. Simples não?
Mas e quando são algumas dezenas ou centenas de arquivos?
Eu fiz o script abaixo, que você apenas diz qual diretório deve ser lido, qual a substituição.
Então ele lê o diretório inteiro em busca dos arquivos .au3, monta um array, e depois abre cada arquivo .au3 e verifica se existe a string $ghGDIPDll, caso exista, ele substitui por $__g_hGDIPDll, salva o arquivo e fecha.
