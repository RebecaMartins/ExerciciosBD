create database dbdistribuidora_rr;
use dbdistribuidora_rr;

-- Criando tabelas

create table tbNotaFiscal (
	NF int primary key,
    TotalNota decimal(6,2) not null,
    DataEmissao date not null
);

create table tbBairro (
	BairroId int primary key auto_increment,
    Bairro varchar(200) not null
);

create table tbCidade(
	CidadeId int primary key auto_increment,
    Cidade varchar(200) not null
);

create table tbEstado (
	UFId int primary key auto_increment,
    UF char(2) not null
);

create table tbFornecedor (
	Cod int primary key auto_increment,
    CNPJ decimal(14,0) unique,
    Nome varchar(200) not null,
    Tel decimal(11,0) 
);
create table tbEndereco(
	CEP decimal(8,0) primary key,
    Logradouro varchar(200) not null,
    BairroId int not null,
    CidadeId int not null,
    UFId int not null,
    constraint FK_BairroId_Endereco foreign key (BairroId) references tbBairro(BairroId),
    constraint FK_CidadeId_Endereco foreign key (CidadeId) references tbCidade(CidadeId),
    constraint FK_UFId_Endereco foreign key (UFId) references tbEstado(UFId)
);

create table tbCliente (
	id int primary key auto_increment,
    NomeCli varchar(300) not null,
    NumEnd decimal(8,0) not null,
    CompEnd varchar(50),
    CepCli decimal(8,0) not null,
	constraint FK_Cep_Cliente foreign key (CepCli) references tbEndereco(Cep) 
);
create table tbClientePf (
	CPF decimal(11,0) primary key,
    RG decimal(9,0) not null,
    RGDig char(1) not null,
    Nasc date not null,
    Id int,
    constraint FK_id_ClientePF foreign key (id) references tbCliente(id)
);

create table tbClientePJ (
	CNPJ decimal(14,0) primary key,
    IE decimal(11,0) unique,
    id INT,
    constraint FK_id_ClientePJ foreign key (id) references tbCliente(id)
);


create table tbProduto(
	CodigoBarras decimal(14,0) primary key,
    Nome varchar(200) not null,
    Valor decimal(6,2) not null,
    Qtd int 
);



create table tbCompra (
	NotaFiscal int primary key,
    DataCompra date not null,
    ValorTotal decimal (6,2) not null,
    QtdTotal int not null,
    Cod int,
    constraint FK_Cod_Compra foreign key (Cod) references tbfornecedor(Cod)
);

create table tbItemCompra(
	NotaFiscal int,
    CodigoBarras decimal(14,0),
    ValorItem decimal(6,2) not null,
    Qtd int not null,
    constraint PK_ItemCompra_Composta primary key(CodigoBarras, NotaFiscal),
    constraint FK_NotaFiscal_ItemCompra foreign key (NotaFiscal) references tbCompra(NotaFiscal),
    constraint FK_CodigoBarras_ItemCompra foreign key (CodigoBarras) references tbProduto(CodigoBarras)
);

create table tbVenda (
	NumeroVenda int primary key,
    DataVenda date not null,
    TotalVenda decimal(6,2) not null,
    IdCli int not null,
    NF int,
    constraint FK_NF_Venda foreign key (NF) references tbNotaFiscal(NF),
    constraint FK_IdCli_Venda foreign key (IdCli) references tbCliente(Id)
);

create table tbItemVenda (
	NumeroVenda int,
    CodigoBarras decimal (14,0) , -- double
    ValorItem decimal(6,2) not null,
    Qtd int not null,
    constraint PK_ItemVenda_Composta primary key(NumeroVenda,CodigoBarras),
    constraint FK_NumeroVenda_ItemVenda foreign key (NumeroVenda) references tbVenda(NumeroVenda),
    constraint FK_CodigoBarras_ItemVenda foreign key (CodigoBarras) references tbProduto(CodigoBarras)
);



-- Exercício(DML) 1

insert into tbFornecedor (CNPJ,Nome,Tel)
values (1245678937123,'Revenda Chico Loco', 11934567897),
(1345678937123,'José Faz Tudo S/A', 11934567898),
(1445678937123,'Vadalto Entregas', 11934567899),
(1545678937123, 'Astrogildo das Estrela', 11934567800),
(1645678937123, 'Amoroso e Doce,', 11934567801),
(1745678937123, 'Marcelo Dedal', 11934567802),
(1845678937123, 'Franciscano Cachaça', 11934567803),
(1945678937123, 'Joãozinho chupeta', 11934567804);
select * from tbFornecedor;
-- Exercício 2
describe tbCidade;
delimiter $$
create procedure spInsertCidade(vCidade varchar(200))
begin
	if not exists(select Cidade from tbCidade where Cidade = vCidade) then 
		insert into tbCidade(cidade) 
		values(vCidade);
    end if;
end $$

call spInsertCidade('Rio de Janeiro');
call spInsertCidade('São Carlos');
call spInsertCidade('Campinas');
call spInsertCidade('Franco da Rocha');
call spInsertCidade('Osasco');
call spInsertCidade('Pirituba');
call spInsertCidade('Lapa');
call spInsertCidade('Ponta Grossa');

-- select * from tbCidade;

-- Exercício 3
describe tbEstado;

delimiter $$
create procedure spInsertEstado(vUF char(2))
begin
	if 
		not exists(select UF from tbEstado where UF = vUF) then
		insert into tbEstado(UF)
		values(vUF);
    end if;
end $$

call spInsertEstado('SP');
call spInsertEstado('RJ');
call spInsertEstado('RS');

-- select * from tbEstado;

-- Exercício 4
describe tbBairro;

delimiter $$
create procedure spInsertBairro(vBairro varchar(200))
begin
	if 
		not exists(select bairro from tbBairro where bairro = vBairro) then
		insert into tbBairro(bairro)
		values(vBairro);
	end if;
end $$

call spInsertBairro('Aclimação');
call spInsertBairro('Capão Redondo');
call spInsertBairro('Pirituba');
call spInsertBairro('Liberdade');

-- select * from tbBairro;

-- Exercício 5
describe tbProduto;

delimiter $$
create procedure spInsertProduto(vCodigoBarras decimal(14,0), vNome varchar(200), vValor Decimal(6,2), vQtd int)
begin
	if
		not exists (select CodigoBarras from tbProduto where CodigoBarras = vCodigoBarras) then
		insert into tbProduto(CodigoBarras, Nome, Valor, Qtd)
        values(vCodigoBarras, vNome, vValor, vQtd);
    end if;
end $$

call spInsertProduto('12345678910111', 'Rei de Papel Mache', 54.61, 120);
call spInsertProduto('12345678910112', 'Bolinha de Sabão', 100.45, 120);
call spInsertProduto('12345678910113', 'Carro Bate', 44.00, 120);
call spInsertProduto('12345678910114', 'Bola Furada ', 10.00, 120);
call spInsertProduto('12345678910115', 'Maçã Laranja', 99.44, 120);
call spInsertProduto('12345678910116', 'Boneco do Hitler', 124.00, 200);
call spInsertProduto('12345678910117', 'Farinha de Suruí', 50.00, 200);
call spInsertProduto('12345678910118', 'Zelador de Cemitério', 24.50, 100);

-- select * from tbProduto;

-- Exercício 6

describe tbEndereco;
describe tbBairro;
describe tbCidade;
describe tbEstado;

delimiter $$
create procedure spInsertEndereco(vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF varchar(200), vCEP decimal(8,0))
begin
	
    if 
		not exists(select bairro from tbBairro where bairro = vBairro) then 
		insert into tbBairro(bairro)
		values(vBairro);
    end if;
    
    if not exists(select Cidade from tbCidade where Cidade = vCidade) then 
		insert into tbCidade(cidade) 
		values(vCidade);
    end if;
    
    if 
		not exists(select UF from tbEstado where UF = vUF) then
		insert into tbEstado(UF)
		values(vUF);
    end if;
    
    insert into tbEndereco(Logradouro, BairroId, CidadeId, UFid, CEP)
    values(vLogradouro, (select BairroId from tbBairro where Bairro = vBairro), (select CidadeId from tbCidade where Cidade= vCidade), (select UFId from tbEstado where UF= vUF), vCep);
    
end $$

call spInsertEndereco('Rua da Federal', 'Lapa', 'São Paulo', 'SP', 12345050);
call spInsertEndereco('Av Brasil', 'Lapa', 'Campinas','SP' ,'12345051');
call spInsertEndereco('Rua Liberdade', 'Consolação', 'São Paulo','SP', '12345052');
call spInsertEndereco('Av Paulista', 'Penha', 'Rio de Janeiro', 'RJ' ,'12345053');
call spInsertEndereco('Rua Ximbú', 'Penha', 'Rio de Janeiro', 'RJ','12345054');
call spInsertEndereco('Rua Piu XI', 'Penha', 'Campinas','SP', '12345055');
call spInsertEndereco('Rua Chocolate', 'Aclimação', 'Barra Mansa', 'RJ', '12345056');
call spInsertEndereco('Rua Pão na Chapa', 'Barra Funda', 'Ponta Grossa', 'RS' ,'12345057');

select * from tbEndereco;

-- Exercício 7
describe tbCliente;
describe tbClientepf;
describe tbEndereco;
select * from tbEndereco;
select * from tbCliente;
select * from tbClientePf;

delimiter $$
create procedure spInsertClientePF(vCEP decimal(8,0), vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF char(2),
    vCPF decimal(11,0), vRG decimal(9,0), vRGDig char(1), vNasc date, vId int,
	vNomeCli varchar(300), vNumEnd decimal(8,0), vCompEnd varchar(50), vCepCli decimal(8,0))
begin
if (not exists(select * from tbEndereco where CEP = vCEP)) then
    if 
		not exists (select * from tbCliente where NomeCli= vNomeCli) then
		insert into tbCliente(NomeCli, NumEnd, CompEnd, CepCli)
		values(vNomeCli, vNumEnd, vCompEnd,(select CepCli from tbCliente where CepCli = vCepCli));
	end if;
    if 
		not exists (select * from tbClientePF where CPF = vCPF) then
        insert into tbClientePF(CPF, RG, RGDig, Nasc, Id)
        values(vCPF, vRG,vRGDig, vNasc,(select Id from tbClientepf where Id = vId));
	end if;
end if;
end $$

/*-- Adicionando endereço dos clientes que faltam
call spInsertEndereco('Rua Veia','Jardim Santa Isabel','Cuiabá', 'MT',12345059);
call spInsertEndereco('Av Nova','Jardim Santa Isabel','Cuiabá', 'MT',12345058);
*/
-- Adicionando Clientes PF

call spInsertClientePF('Pimpão', 325 ,null, 12345051, 12345678911, 12345678, 0, '2000-10-12');
call spInsertClientePF('Disney Chaplin', 89, 'Ap. 12', 12345053, 12345678912, 12345679,0,'2001-11-21');
call spInsertClientePF('Marciano', 744, null, 12345054, 12345678913, 12345680, 0, '2001-06-01');
call spInsertClientePF('Lança Perfume', 128, null, 12345059, 12345678914, 12345681, 'X', '2004-04-05');
call spInsertClientePF('Remédio Amargo', 2585, null, 12345058, 12345678915, 12345682, 0, '2002-07-15');


-- Exercício 8 
describe tbClientePJ;
select * from tbClientePJ;
-- Adicionando os endereços primeiro

delimiter $$
create procedure spInsertClientePJ(vCEP decimal(8,0), vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF char(2),
	vNomeCli varchar(300), vNumEnd decimal(8,0), vCompEnd varchar(50), vCepCli decimal(8,0), 
	vCNPJ decimal(14,0) ,vIE decimal(11,0), vid int)
begin
if (not exists(select * from tbEndereco where CEP = vCEP)) then
    if 
		not exists (select * from tbCliente where NomeCli= vNomeCli) then
		insert into tbCliente(NomeCli, NumEnd, CompEnd, CepCli)
		values(vNomeCli, vNumEnd, vCompEnd,(select CepCli from tbCliente where CepCli = vCepCli));
	end if;
    if
		not exists (select * from tbClientePJ where CNPJ = vCNPJ) then
        insert into tbClientePJ(CNPJ, IE, id)
        values(vCNPJ, vIE,(select id from tbClientePJ where id = vid));
	end if;
end if;
end $$

-- call spInsertEndereco('Rua dos Amores', 'Sei Lá', 'Recife', 'PE', 12345060);

call spInsertClientePJ('Paganada', 159, null, 12345051, 12345678912345, 98765432198);
call spInsertClientePJ('Caloteando', 69, null, 12345053,12345678912346, 98765432199);
call spInsertClientePJ('Semgrana', 189, null, 12345060, 12345678912347, 98765432100);
call spInsertClientePJ('Cemreais', 5024, 'Sala 23', 12345060, 12345678912348, 98765432101);
call spInsertClientePJ('Durango', 1254, null, 12345060, 12345678912349, 98765432102);

-- Exercício 9
select * from tbFornecedor;
select * from tbProduto;
describe tbNotaFiscal;
describe tbFornecedor;
describe tbProduto;
describe tbCompra; -- NotaFiscal, DataCompra, ValorTotal, QtdTotal ID(fornecedor) 
describe tbItemCompra;
describe tbCompra;

delimiter $$
							-- primeiro tbCompra, depois tbItemCompra
create procedure spInsertCompra(vCod int, vCNPJ decimal(14,0), vNome varchar(200), vTel decimal(11,0),
	vCodigoBarras decimal(14,0), vNome varchar(200), vValor decimal(6,2), vQtd int,
	vNotaFiscal int, vCodigoBarras decimal(14,0), vValorItem decimal(6,2), vQtd int,
    vNotaFiscal int, vDataCompra char(10), vValorTotal decimal(6,2), vQtdTotal int, vCod int)
begin	
if exists(select * from tbFornecedor where Cod = vCod) then
	if exists(select * from tbProduto where CodigoBarras = vCodigoBarras) then
    -- COLOCA COISA AQ
    end if;
end if;
end $$

call spInsertCompra(8459, '01-05-2018', 2194.40, 700, 'Amoroso e Doce', 12345678910111, 22.22, 200); 
select * from tbItemCompra;
select * from tbCompra;

-- Exercicio 11 --
delimiter $$
create procedure spInsertNotaFiscal (vNF int, vCliente varchar(50))
begin
if exists (select Id from tbCliente where Nome = vCliente) then
	if not exists (select NF from tbNotaFiscal where NF = vNF) then
		set @IdCliente = (select Id from tbCliente where Nome = vCliente);
		set @TotalNota = (select NF (TotalVenda) from tbVenda where IdCliente = @IdCliente);
		set @DataVenda = current_date();
    
		if exists (select NumeroVenda from tbVenda where IdCliente = @IdCliente) then
			insert into tbNotaFiscal (NF, TotalNota, DataEmissao) values (vNF, @TotalNota, @DataVenda);
		else
			select "Esse Cliente não realizou nenhum pedido";
		end if;
	else
		select "A nota fiscal já existe";
	end if;
else
	select "Esse cliente não existe";
end if;
end
$$

call spInsertNF(359, "Pimpão");
call spInsertNF(360, "Lança Perfume");

select tbNotaFiscal;
select tbCliente;
select tbClientePF;

-- Exercicio 12 --
call insertProduto(12345678910130, 'Camiseta de Poliéster', 35.61, 100);
call insertProduto(12345678910131, 'Blusa frio moletom', 200.00, 100);
call insertProduto(12345678910132, 'Vestido Decote Redondo', 144.00, 50);
 
-- Exercicio 13 --
DELIMITER $$
create procedure spDeleteProduto(vCodigoBarras bigint)
BEGIN
	if exists (select CodBarras from tbproduto where CodBarras = vCodigoBarras) then
		delete from tbproduto where CodBarras = vCodigoBarras;
		else 
			select "O produto não existe";
    end if;
END
$$

call spDeleteProduto(12345678910116);
call spDeleteProduto(12345678910117);

select * from tbProduto;

-- exercicio 16 --
create table tbProdutoHistorico like tbProduto;

-- ex17
alter table tbProdutoHistorico add Ocorrencia varchar(20);
alter table tbProdutoHistorico add Atualizacao datetime;

-- ex18
ALTER TABLE tbProdutoHistorico DROP PRIMARY KEY, ADD PRIMARY KEY(CodBarras, Ocorrencia, Atualizacao);

-- ex19
delimiter $$
create trigger trgProdHistorico after insert on tbProduto
	for each row
  begin
  insert into tbProdutoHistorico
		set CodBarras = new.CodBarras,
			Nome = new.Nome,
            ValorUnitario = new.ValorUnitario,
            qtd = new.qtd,
            Ocorrencia = 'Produto Novo',
            Atualizacao = current_timestamp();
  end;
$$
select * from tbProdutoHistorico;
call insertProduto(12345678910119, 'Água mineral', 1.99, 500);

-- ex20 

delimiter $$
create trigger trgProdHistoricoUpdate before update on tbProduto
	for each row
  begin
  insert into tbProdutoHistorico
		set CodBarras = new.CodBarras,
		Nome = new.Nome,
        ValorUnitario = new.ValorUnitario,
        qtd = new.qtd,
        Ocorrencia = 'Atualizado',
        Atualizacao = current_timestamp();
  end;
$$
-- call
call spAtualizarProduto(12345678910119, 'Água mineral', 2.99);

-- ex 26 (uma condição que dimiui um produto do estoque no inventário a cada compra)
delimiter && create trigger trgQtdHistorico after insert on tbitemvenda 
for each row begin update tbProduto set qtd = (qtd - new.qtd) where CodigoBarras = new.CodigoBarras; end &&

select * from tbProduto;

-- ex 27 (insert de um novo produto vendido)
call spInsertVenda(5, "Paganada", 12345678910114, 10.00, 15, null);

-- ex 28
call spselectProduto;

-- ex 29 (adicionado uma nova compra no historico)
delimiter && create trigger trgQtdCompra after insert on tbitemcompra 
for each row begin update tbProduto set qtd = (qtd + new.qtd) where CodigoBarras = new.CodigoBarras; end &&

-- ex 30 (nova compra)
call spInsertCompra(10548, 'Amoroso e Doce', str_to_date('10/09/2022','%d/%m/%Y'), 12345678910111, 40.00, 100, 4000.00);

-- ex 31 
call spselectProduto;

-- ex 32 (selects com join)
select * from tbCliente inner join tbClientePF ON tbCliente.ID = tbClientePF.ID;

-- ex 33
 select * from tbCliente inner join tbClientePJ ON tbCliente.ID = tbClientePJ.ID;

-- ex 34
select tbCliente.ID, tbClientePJ from tbCliente inner join tbClientePJ ON tbCliente.ID = tbClientePJ.ID;

-- ex 35 (aqui pede pra executar tudo do cliente pessoa fisica)
select tbCliente.ID as codigo, tbCliente.NomeCli as nome, tbClientePF.CPF as CPF, tbClientePF.RG as RG, 
tbClientePF.Nasc as "data de nascimento" from tbCliente inner join tbClientePF on tbCliente.ID = tbClientePF.ID;