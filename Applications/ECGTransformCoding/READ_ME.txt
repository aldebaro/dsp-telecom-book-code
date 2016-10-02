############ Softwares for coding with an arbitrary linear transform

1) Main code
ak_testBlockEncodingDecoding.m - exemplo de co/descodificacao
ak_testBlockCodingRateDistortionCurve.m - exemplo de gerar curva RT por MSE

2) Auxiliary block transform code
ak_1dBlockTransform.m - multiplica por matriz. Pode ser usado em codificacao e descodificacao
ak_1dBlockCoding.m - usa o ak_1dBlockTransform.m para fazer codificacao
ak_1dBlockDecoding.m - usa o ak_1dBlockTransform.m para fazer descodificacao

3) Auxiliary code for dealing with ECG files. Os arquivos abaixo são uma função para ler arquivos de ECG e um script
para testar essa função de leitura. 
ak_rddata.m           - reads the ECG files
ak_test_rddata.m      - test the previous function

############ Dataset:

A base de dados foi tirada de:
http://www.physionet.org/physiobank/database/cdb/
Informacoes extras podem ser encontradas em:
http://ecg.mit.edu/dbinfo.html
http://www.physionet.org/physiobank/

O arquivo .dat tem a forma de onda e o .hea eh o "header" (cabecalho)
Para entender melhor o formato dos arquivos, vide:
http://www.physionet.org/faq.shtml#physiobank

O subconjunto "pequeno" tem a divisao:

Training set (use it to design the transform, obtain covariance matrices, etc. Do not use for evaluation purposes)
08730_01.dat  08730_02.dat  08730_04.dat  08730_03.dat  11442_02.dat  12531_04.dat  

Test set (use for evaluation purposes)
11950_03.dat  12713_01.dat  11442_01.dat  12247_03.dat  

Note que todos os arquivos tem dois canais de ECG. Ou seja, em cada arquivo há dois sinais a serem codificados.

