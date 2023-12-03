create database dbdistribuidora_rr;
use dbdistribuidora_rr;

-- Criando tabelas
create table tbNotaFiscal(
	NF int primary key,
    TotalNota decimal(6,2) not null,
    DataEmissao date not null
);

create table tbBairro(
	BairroId int primary key auto_increment,
    Bairro varchar(200) not null
);

create table tbCidade(
	CidadeId int primary key auto_increment,
    Cidade varchar(200) not null
);

create table tbEstado(
	UFId int primary key auto_increment,
    UF char(2) not null
);

create table tbFornecedor(
	CodFornecas int primary key auto_increment,
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

create table tbCliente(
	id int primary key auto_increment,
    NomeCli varchar(300) not null,
    NumEnd decimal(8,0) not null,
    CompEnd varchar(50),
    CepCli decimal(8,0) not null,
	constraint FK_Cep_Cliente foreign key (CepCli) references tbEndereco(Cep) 
);

create table tbClientePF(
	CPF decimal(11,0) primary key,
    RG decimal(9,0) not null,
    RGDig char(1) not null,
    Nasc date not null,
    Id int,
    constraint FK_id_ClientePF foreign key (id) references tbCliente(id)
);

create table tbClientePJ(
	CNPJ decimal(14,0) primary key,
    IE decimal(11,0) unique,
    id INT,
    constraint FK_id_ClientePJ foreign key (id) references tbCliente(id)
);

create table tbProduto(
	CodigoBarrasProd decimal(14,0) primary key,
    NomeProd varchar(200) not null,
    Valor decimal(6,2) not null,
    QtdProd int 
);

create table tbCompra(
	NotaFiscalCompra int primary key,
    DataCompra date not null,
    ValorTotal decimal (8,2) not null,
    QtdTotal int not null,
    Cod int,
    constraint FK_Cod_Compra foreign key (Cod) references tbfornecedor(CodFornecas)
);

create table tbItemCompra(
	NotaFiscalItem int,
    CodigoBarras decimal(14,0),
    ValorItem decimal(8,2) not null,
    QtdItem int not null,
    constraint PK_ItemCompra_Composta primary key(CodigoBarras, NotaFiscalItem),
    constraint FK_NotaFiscal_ItemCompra foreign key (NotaFiscalItem) references tbCompra(NotaFiscalCompra),
    constraint FK_CodigoBarras_ItemCompra foreign key (CodigoBarras) references tbProduto(CodigoBarrasProd)
);

create table tbVenda(
	NumeroVenda int primary key,
    DataVenda date not null,
    TotalVenda decimal(6,2) not null,
    IdCli int not null,
    NF int,
    constraint FK_NF_Venda foreign key (NF) references tbNotaFiscal(NF),
    constraint FK_IdCli_Venda foreign key (IdCli) references tbCliente(Id)
);

create table tbItemVenda(
	NumeroVenda int,
    CodigoBarrasVenda decimal (14,0),
    ValorItem decimal(6,2) not null,
    Qtd int not null,
    constraint PK_ItemVenda_Composta primary key(NumeroVenda, CodigoBarrasVenda),
    constraint FK_NumeroVenda_ItemVenda foreign key (NumeroVenda) references tbVenda(NumeroVenda),
    constraint FK_CodigoBarras_ItemVenda foreign key (CodigoBarrasVenda) references tbProduto(CodigoBarrasProd)
);

-- Exercício 1
insert into tbFornecedor (CNPJ,Nome,Tel)
values (1245678937123,'Revenda Chico Loco', 11934567897),
(1345678937123,'José Faz Tudo S/A', 11934567898),
(1445678937123,'Vadalto Entregas', 11934567899),
(1545678937123, 'Astrogildo das Estrela', 11934567800),
(1645678937123, 'Amoroso e Doce,', 11934567801),
(1745678937123, 'Marcelo Dedal', 11934567802),
(1845678937123, 'Franciscano Cachaça', 11934567803),
(1945678937123, 'Joãozinho chupeta', 11934567804);

-- Exercício 2
delimiter $$
create procedure spInsertCidade(vCidade varchar(200))
begin
	if (not exists(select Cidade from tbCidade where Cidade = vCidade)) then 
		insert into tbCidade(cidade) 
		values(vCidade);
	else
		select "Calma aí paizão, cidade já cadastrada.";
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

-- Exercício 3
delimiter $$
create procedure spInsertEstado(vUF char(2))
begin
	if (not exists(select UF from tbEstado where UF = vUF)) then
		insert into tbEstado(UF)
		values(vUF);
	else
		select "Calma aí paizão, estado já cadastrado.";
    end if;
end $$

call spInsertEstado('SP');
call spInsertEstado('RJ');
call spInsertEstado('RS');

-- Exercício 4
delimiter $$
create procedure spInsertBairro(vBairro varchar(200))
begin
	if (not exists(select bairro from tbBairro where bairro = vBairro)) then
		insert into tbBairro(bairro)
		values(vBairro);
	else
		select "Calma aí paizão, bairro já cadastrado.";
	end if;
end $$

call spInsertBairro('Aclimação');
call spInsertBairro('Capão Redondo');
call spInsertBairro('Pirituba');
call spInsertBairro('Liberdade');

-- Exercício 5
delimiter $$
create procedure spInsertProduto(vCodigoBarrasProd decimal(14,0), vNomeProd varchar(200), vValor Decimal(6,2), vQtdProd int)
begin
	if (not exists (select CodigoBarrasProd from tbProduto where CodigoBarrasProd = vCodigoBarrasProd)) then
		insert into tbProduto(CodigoBarrasProd, NomeProd, Valor, QtdProd)
        values(vCodigoBarrasProd, vNomeProd, vValor, vQtdProd);
	else
		select "Calma aí paizão, produto já cadastrado.";
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

-- Exercício 6
delimiter $$
create procedure spInsertEndereco(vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF varchar(200), vCEP decimal(8,0))
begin
if (not exists(select CEP from tbEndereco where CEP = vCEP)) then
    if (not exists(select bairro from tbBairro where bairro = vBairro)) then 
		insert into tbBairro(bairro)
		values(vBairro);
    end if;
    if (not exists(select Cidade from tbCidade where Cidade = vCidade)) then 
		insert into tbCidade(cidade) 
		values(vCidade);
    end if;
    if (not exists(select UF from tbEstado where UF = vUF)) then
		insert into tbEstado(UF)
		values(vUF);
    end if;
    
    insert into tbEndereco(Logradouro, BairroId, CidadeId, UFid, CEP)
    values(vLogradouro, (select BairroId from tbBairro where Bairro = vBairro), (select CidadeId from tbCidade where Cidade= vCidade), (select UFId from tbEstado where UF= vUF), vCEP);
else
		select "Calma aí paizão, endereço já cadastrado.";
end if;
end $$

call spInsertEndereco('Rua da Federal', 'Lapa', 'São Paulo', 'SP', 12345050);
call spInsertEndereco('Av Brasil', 'Lapa', 'Campinas','SP' ,'12345051');
call spInsertEndereco('Rua Liberdade', 'Consolação', 'São Paulo','SP', '12345052');
call spInsertEndereco('Av Paulista', 'Penha', 'Rio de Janeiro', 'RJ' ,'12345053');
call spInsertEndereco('Rua Ximbú', 'Penha', 'Rio de Janeiro', 'RJ','12345054');
call spInsertEndereco('Rua Piu XI', 'Penha', 'Campinas','SP', '12345055');
call spInsertEndereco('Rua Chocolate', 'Aclimação', 'Barra Mansa', 'RJ', '12345056');
call spInsertEndereco('Rua Pão na Chapa', 'Barra Funda', 'Ponta Grossa', 'RS' ,'12345057');

-- Exercício 7
delimiter $$
create procedure spInsertClientePF(vNomeCli varchar(200), vNumEnd int, vCompEnd varchar(50), vCepCli bigint,
	vCPF bigint, vRG int, vRGDig char(1), vNasc char(10),
	vCEP bigint, vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF char(2))
begin
if (not exists(select CPF from tbClientePF where CPF = vCPF)) then
	if (not exists(select CEP from tbEndereco where CEP = vCEP)) then
		if (not exists (select Bairro from tbBairro where Bairro = vBairro))then
			insert into tbBairro (Bairro)
				values(vBairro);
			end if;
		if (not exists (select Cidade from tbCidade where Cidade = vCidade)) then
				insert into tbCidade(Cidade)
				values(vCidade);
		end if;
			if (not exists(select UF from tbEstado where UF = vUF)) then
				insert into tbEstado(UF)
				values(vUF);
			end if;       
        
		insert into tbEndereco(Logradouro, BairroId, CidadeId, UFid, CEP)
        values(vLogradouro, (select BairroId from tbBairro where Bairro = vBairro), (select CidadeId from tbCidade where Cidade= vCidade), (select UFId from tbEstado where UF= vUF), vCEP);
    end if;
			
		insert into tbCliente(NomeCli, NumEnd, CompEnd, CepCli)
		values(vNomeCli, vNumEnd, vCompEnd, vCEP);
			
		insert into tbClientePF(CPF, RG , RGDig, Nasc, Id)
		values (vCPF, vRG, vRGDig, str_to_date(vNasc,'%d/%m/%Y'), (select id from tbCliente order by id limit 1));

else
	select "Calma aí paizão, pessoa física já cadastrada.";
end if;
end $$

call spInsertClientePF('Pimpão', 325 , null, 12345051, 12345678911, 12345678, 0, '12/10/2000', 12345051, 'Av Brasil', 'Lapa', 'Campinas', 'SP');
call spInsertClientePF('Disney Chaplin', 89, 'Ap. 12', 12345053, 12345678912, 12345679, 0, '21/11/2001', 12345053, 'Av Paulista', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertClientePF('Marciano', 744, null, 12345054, 12345678913, 12345680, 0, '01/06/2001', 12345054, 'Rua Ximbú', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertClientePF('Lança Perfume', 128, null, 12345059, 12345678914, 12345681, 'X', '05/04/2004', 12345059, 'Rua Veia', 'Jardim Santa Isabel', 'Cuiabá', 'MT');
call spInsertClientePF('Remédio Amargo', 2585, null, 12345058, 12345678915, 12345682, 0, '15/07/2002', 12345058, 'Av Nova', 'Jardim Santa Isabel', 'Cuiabá', 'MT');

-- Exercício 8 
delimiter $$
create procedure spInsertClientePJ(vNomeCli varchar(200), vNumEnd int, vCompEnd varchar(50), vCepCli bigint,
	vCNPJ bigint, vIE bigint,
	vCEP bigint, vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF char(2))
begin
if (not exists(select CNPJ from tbClientePJ where CNPJ = vCNPJ)) then
	if (not exists(select CEP from tbEndereco where CEP = vCEP)) then
		if (not exists (select Bairro from tbBairro where Bairro = vBairro))then
			insert into tbBairro (Bairro)
				values(vBairro);
			end if;
		if (not exists (select Cidade from tbCidade where Cidade = vCidade)) then
				insert into tbCidade(Cidade)
				values(vCidade);
		end if;
			if (not exists(select UF from tbEstado where UF = vUF)) then
				insert into tbEstado(UF)
				values(vUF);
			end if;       
        
		insert into tbEndereco(Logradouro, BairroId, CidadeId, UFid, CEP)
        values(vLogradouro, (select BairroId from tbBairro where Bairro = vBairro), (select CidadeId from tbCidade where Cidade= vCidade), (select UFId from tbEstado where UF= vUF), vCEP);
    end if;
			
	insert into tbCliente(NomeCli, NumEnd, CompEnd, CepCli)
	values(vNomeCli, vNumEnd, vCompEnd, vCEP);
    
    insert into tbClientePJ(CNPJ, IE, id)
    values(vCNPJ, vIE, (select id from tbCliente order by id limit 1));
else
	select "Calma aí paizão, pessoa juridica já cadastrada.";
end if;
end $$

call spInsertClientePJ('Paganada', 159, null, 12345051, 12345678912345, 98765432198, 12345051, 'Av Brasil', 'Lapa', 'Campinas', 'SP');
call spInsertClientePJ('Caloteando', 69, null, 12345053, 12345678912346, 98765432199, 12345053, 'Av Paulista', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertClientePJ('Semgrana', 189, null, 12345060, 12345678912347, 98765432100, 12345060, 'Rua dos Amores', 'Sei Lá', 'Recife', 'PE');
call spInsertClientePJ('Cemreais', 5024, 'Sala 23', 12345060, 12345678912348, 98765432101, 12345060, 'Rua dos Amores', 'Sei Lá', 'Recife', 'PE');
call spInsertClientePJ('Durango', 1254, null, 12345060, 12345678912349, 98765432102, 12345060, 'Rua dos Amores', 'Sei Lá', 'Recife', 'PE');

-- Exercicio 9 --
delimiter &&
create procedure spInsertCompra(vNotaFiscalCompra int, vNome varchar(200), vDataCompra char(10), 
vCodigoBarrasProd decimal(14,0), vValorItem decimal (8,2), vQtdItem int, vQtdTotal int, vValorTotal decimal (8,2))
begin
if not exists (select NotaFiscalCompra from tbCompra where NotaFiscalCompra = vNotaFiscalCompra) then
	if exists (select CodFornecas from tbFornecedor where Nome = vNome) and 
	exists (Select CodigoBarrasProd from tbProduto where CodigoBarrasProd = vCodigoBarrasProd) then

		insert into tbCompra(NotaFiscalCompra, DataCompra, ValorTotal, QtdTotal, Cod)
			values (vNotaFiscalCompra, str_to_date(vDataCompra, '%d/%m/%Y'), vValorTotal, vQtdTotal, 
			(select CodFornecas from tbFornecedor where Nome = vNome));

		insert into tbItemCompra(NotaFiscalItem, CodigoBarras, ValorItem, QtdItem) 
			values (vNotaFiscalCompra, vCodigoBarrasProd ,vValorItem, vQtdItem);
		end if;
	else
    describe tbItemCompra;
					if not exists (select * from tbItemCompra where NotaFiscalItem = vNotaFiscalCompra and CodigoBarras = vCodigoBarrasProd) then
						insert into tbItemCompra(NotaFiscalItem, CodigoBarras, ValorItem, QtdItem) 
							values (vNotaFiscalCompra, vCodigoBarrasProd, vValorItem, vQtdItem);
						end if; 
	end if;        
end &&

call spInsertCompra(8459, 'Amoroso e Doce', '01/05/2018', 12345678910111, 22.22, 200, 700, 21944.00);
call spInsertCompra(2482, 'Revenda Chico Loco', '22/04/2020', 12345678910112, 40.50, 180, 180,  7290.00 );
call spInsertCompra(21563, 'Marcelo Dedal', '12/07/2020', 12345678910113, 3.00, 300, 300, 900.00);
call spInsertCompra(8459, 'Amoroso e Doce', '04/12/2020', 12345678910114, 35.00, 500, 700, 21944.00);
call spInsertCompra(156354 , 'Revenda Chico Loco', '23/11/2021', 12345678910115, 54.00, 350, 350, 18900.00);

-- Exercício 10
delimiter &&
create procedure spInsertVenda(vNumeroVenda int, vNomeCli varchar(200), vCodigoBarrasProd numeric(14), vValorItem decimal(8,3), vQtd int, vNF int)
begin 

		if (select ID from tbCliente where NomeCli = vNomeCli) then 
			set @ID = (select ID from tbCliente where NomeCli = vNomeCli);
            set @NotaFiscal = (select NF from tbNotaFiscal where NF = vNF);
            set @total = (select valor from tbProduto where CodigoBarrasProd = vCodigoBarrasProd) * vQtd;
            
            if (select CodigoBarrasProd from tbProduto where CodigoBarrasProd = vCodigoBarrasProd) then
				if not exists (select NumeroVenda from tbVenda where NumeroVenda = vNumeroVenda) then 
					insert into tbvenda (NumeroVenda, DataVenda, TotalVenda, IDCli, NF) 
						values (vNumeroVenda, current_date(), @total, @ID, vNF);
                        
                    insert into tbItemVenda (NumeroVenda, CodigoBarrasVenda, ValorItem, Qtd) 
						values (vNumeroVenda, vCodigoBarrasProd, vValorItem, vQtd);
				end if;
            end if;
		end if;
end &&

call spInsertVenda (1, 'Pimpão', 12345678910111, 54.61, 1, null);
call spInsertVenda (2, 'Lança Perfume', 12345678910112, 100.45, 2, null);
call spInsertVenda (3, 'Pimpão', 12345678910113, 44.00, 1, null);
call spInsertVenda(4, "Paganada", 12345678910114, 10.00, 20, null);

-- Exercicio 11 --
delimiter $$
create procedure spInsertNF(vNF int, vNomeCli varchar(200))
begin
declare vTotalNota decimal(8,2);
if exists(select NomeCli from tbCliente where NomeCli = vNomeCli) then
	if not exists(select NF from tbNotaFiscal where NF = vNF) then
    set vTotalNota = (select sum(TotalVenda) from tbVenda where IdCli = (select id from tbCliente where Nomecli = vNomecli));
    
	insert into tbNotaFiscal(NF, TotalNota, DataEmissao)
	values(vNF, vTotalNota, current_date());
	end if;
end if;
end $$

call spInsertNF (359, 'Pimpão'); 
call spInsertNF (360, 'Lança Perfume');

-- Exercício 12
call spInsertProduto(12345678910130, 'Camiseta de Poliéster', 35.61, 100);
call spInsertProduto(12345678910131, 'Blusa Frio Moletom', 200.00, 100);
call spInsertProduto(12345678910132, 'Vestido Decote Redondo', 144.00, 50);

-- Exercício 13
delimiter $$
create procedure spApagarProdutos()
begin
	delete from tbProduto where CodigoBarrasProd = '12345678910116';
    delete from tbProduto where CodigoBarrasProd = '12345678910117';
end $$

call spApagarProdutos();

-- Exercício 14
delimiter $$
create procedure spAtualizaProduto(vCodigoBarrasProd decimal(14,0), vNomeProd varchar(200), vValor decimal(6,2), vQtdProd int)
begin
	if exists(select * from tbProduto where vCodigoBarrasProd = vCodigoBarrasProd) then
		update tbProduto set NomeProd = vNomeProd, Valor = vValor, QtdProd = vQtdProd
		where CodigoBarrasProd = vCodigoBarrasProd;
	end if;
end $$

call spAtualizaProduto(12345678910111, 'Rei de Papel Mache',  64.50, 120);
call spAtualizaProduto(12345678910112, 'Bolinha de Sabão', 120.00, 120);
call spAtualizaProduto(12345678910113, 'Carro Bate', 64.00, 120);

-- Exercício 15
delimiter $$
create procedure spMostrarProdutos()
begin
	select * from tbProduto;
end $$

call spMostrarProdutos();

-- Exercicio 16
create table tbProdutoHistorico like tbProduto;

-- Exercicio 17
alter table tbProdutoHistorico add Ocorrencia varchar(20);
alter table tbProdutoHistorico add Atualizacao datetime;

-- Exercicio 18
alter table tbProdutoHistorico drop primary key, add primary key(CodigoBarrasProd, Ocorrencia, Atualizacao);

-- Exercicio 19
delimiter $$
create trigger trgProdHistorico after insert on tbProduto
for each row
begin
insert into tbProdutoHistorico
	set CodigoBarrasProd = new.CodigoBarrasProd,
	NomeProd = new.NomeProd,
	Valor = new.Valor,
	QtdProd = new.QtdProd,
	Ocorrencia = 'Produto Novo',
	Atualizacao = current_timestamp();
end $$

call spInsertProduto(12345678910119, 'Água mineral', 1.99, 500);

-- Exercicio 20 
delimiter $$
create trigger trgProdHistoricoUpdate before update on tbProduto
for each row
begin
insert into tbProdutoHistorico
	set CodigoBarrasProd = new.CodigoBarrasProd,
	NomeProd = new.NomeProd,
	Valor = new.Valor,
	QtdProd = new.QtdProd,
	Ocorrencia = 'Atualizado',
	Atualizacao = current_timestamp();
end $$

call spAtualizaProduto(12345678910119, 'Água mineral', 2.99, 500);

-- Exercício 21
select * from tbProduto;

-- Exercício 22
call spInsertVenda(5, 'Disney Chaplin', 12345678910111, 65.00, 1, null);

-- Exercício 23
select * from dbdistribuidora_rr.tbVenda
order by NumeroVenda desc limit 1;

-- Exercício 24
select * from dbdistribuidora_rr.tbItemVenda
order by NumeroVenda desc limit 1;

-- Exercício 25
delimiter $$
create procedure spBuscarCliente()
begin
    select * from dbdistribuidora_rr.tbCliente
    where NomeCli = "Disney Chaplin";
end $$

call spBuscarCliente();

-- Exercicio 26 (uma condição que dimiui um produto do estoque no inventário a cada compra)
delimiter &&
create trigger trgAttQtd after insert on tbItemVenda
for each row
begin
    update tbProduto set qtdProd = (qtdProd - new.qtd) where CodigoBarrasProd = new.CodigoBarrasVenda;
end &&

-- Exercicio 27 (insert de um novo produto vendido)
call spInsertVenda(6, "Paganada", 12345678910114, 10.00, 15, null);

-- Exercicio 28
call spMostrarProdutos();

-- Exercicio 29 (adicionado uma nova compra no historico)
delimiter &&
create trigger trgQtdCompra after insert on tbItemCompra 
for each row begin 
    update tbProduto set QtdItem = (QtdItem + new.QtdItem) where CodigoBarras = new.CodigoBarras;
end &&

-- Exercicio 30 (Nova compra)
call spInsertCompra(10548, 'Amoroso e Doce', '10/09/2022', 12345678910111, 40.00, 100, 100, 4000.00);

-- Exerciocio 31 
select * from tbProduto;

-- Exercicio 32 (Selects com join)
select * from tbCliente inner join tbClientePF ON tbCliente.ID = tbClientePF.ID;

-- Exercicio 33
select * from tbCliente inner join tbClientePJ ON tbCliente.ID = tbClientePJ.ID;

-- Exercicio 34
select tbCliente.ID, tbCliente.NomeCli, tbClientePJ.CNPJ, tbClientePJ.IE, tbClientePJ.ID from tbCliente inner join tbClientePJ ON tbCliente.ID = tbClientePJ.ID;

-- Exercicio 35 (Aqui pede pra executar tudo do cliente pessoa fisica)
select tbCliente.ID as id, tbCliente.NomeCli as NomeCli, tbClientePF.CPF as CPF, tbClientePF.RG as RG, 
tbClientePF.Nasc as "data de nascimento" from tbCliente inner join tbClientePF on tbCliente.ID = tbClientePF.ID;

-- Exercício 36
select 
    tbCliente.ID as id, 
    tbCliente.NomeCli as NomeCli, 
    tbCliente.NumEnd as NumEnd, 
    tbCliente.CompEnd as CompEnd, 
    tbCliente.CepCli as CliCEP,
    tbClientePJ.CNPJ as CNPJ, 
    tbClientePJ.IE as IE,
    tbEndereco.Logradouro as Logradouro, 
    tbEndereco.BairroId as BairroId, 
    tbEndereco.CidadeId as CidadeId, 
    tbEndereco.UFId as UFId, 
    tbEndereco.CEP as EndCEP 
from 
    tbCliente
inner join 
    tbClientePJ ON tbCliente.ID = tbClientePJ.ID
inner join 
    tbEndereco ON tbCliente.CepCli = tbEndereco.CEP;

-- Exercício 37
select 
    tbCliente.ID as id, 
    tbCliente.NomeCli as NomeCli, 
    tbCliente.NumEnd as NumEnd, 
    tbCliente.CompEnd as CompEnd,
    tbEndereco.CEP as CEP, 
    tbEndereco.Logradouro as Logradouro,
    tbBairro.Bairro as Bairro, 
    tbCidade.Cidade as Cidade, 
    tbEstado.UF as UF 
from
    tbCliente
inner join
    tbEndereco ON tbCliente.CepCli = tbEndereco.CEP
inner join
    tbBairro ON tbEndereco.BairroId = tbBairro.BairroId
inner join 
    tbCidade ON tbEndereco.CidadeId = tbCidade.CidadeId
inner join
    tbEstado ON tbEndereco.UFId = tbEstado.UFId;

-- Exercício 38
delimiter $$
create procedure spMostraRegistro(IN id INT)
begin
    select
        tbCliente.ID as 'Código',
        tbCliente.NomeCli as 'Nome',
        tbClientePF.CPF as 'CPF',
        tbClientePF.RG as 'RG',
        tbClientePF.RGDig as 'Digito',
        tbClientePF.Nasc as 'Data de Nascimento',
        tbEndereco.CEP as 'CEP',
		tbEndereco.Logradouro as 'Logradouro',
        tbCliente.NumEnd as 'Número',
        tbCliente.CompEnd as 'Complemento',
        tbEndereco.BairroId as 'Bairro',
        tbEndereco.CidadeId as 'Cidade',
        tbEndereco.UFId as 'UF'
    from 
        tbCliente
    inner join 
        tbClientePF ON tbCliente.ID = tbClientePF.ID
    inner join 
        tbEndereco ON tbCliente.CepCli = tbEndereco.CEP
    inner join 
        tbBairro ON tbEndereco.BairroId = tbBairro.BairroId
    inner join 
        tbCidade ON tbEndereco.CidadeId = tbCidade.CidadeId
    inner join 
        tbEstado ON tbEndereco.UFId = tbEstado.UFId
    where 
        tbCliente.ID = id;
end $$

call spMostraRegistro(1);
-- Por algum motivo, todos os select's estão indo no primeiro, problema que não conseguimos resolver
call spMostraRegistro(2);
call spMostraRegistro(3);
call spMostraRegistro(4);
call spMostraRegistro(5);

-- Exercício 39
select * from tbItemVenda left join tbProduto on tbItemVenda.CodigoBarrasVenda = tbProduto.CodigoBarrasProd;

-- Exercício 40
select * from tbNotaFiscal right join tbFornecedor on tbNotaFiscal.NF = tbFornecedor.CodFornecas;

-- TALVEZ TERÁ MAIS EXERCÍCIOS, MAS DO 1 PARA O 40 ESTÁ COMPLETO(Menos a 38 :((()