alter type stock_ty
add member function yield return float 
cascade
/

create or replace type body stock_ty as
member function yield return float is
	begin
		return ((self.ldividend/self.cprice)*100);
	end;
end;


alter type stock_ty 
add member function AUDtoUSD(rate float) return float
cascade
/

create or replace type body stock_ty as
member function yield return float is
	begin
		return ((self.ldividend/self.cprice)*100);
	end yield;
member function AUDtoUSD(rate float) return float is
	begin
		return self.cprice*rate;
	end AUDtoUSD;
end;

alter type stock_ty 
add member function no_of_trades return integer
cascade
/

create or replace type body stock_ty as
member function yield return float is
	begin
		return ((self.ldividend/self.cprice)*100);
	end yield;
member function AUDtoUSD(rate float) return float is
	begin
		return self.cprice*rate;
	end AUDtoUSD;
member function no_of_trades return integer is
	countt integer;
	begin
		select count(e.column_value) into countt
		from table(self.ex_traded) e;
		return countt;
	end no_of_trades;
end;

alter type client_ty
add member function tot_purchase_val return float
cascade
/

create type body client_ty as 
member function tot_purchase_val return float is
	pvalue float;
	begin
		select sum(i.pprice*i.qty) into pvalue
		from table(self.investments) i;
		return pvalue;
	end;
end;

alter type client_ty 
add member function tot_profit return float
cascade
/

create or replace type body client_ty as
member function tot_purchase_val return float is
	pvalue float;
	begin
		select sum(i.pprice*i.qty) into pvalue
		from table(self.investments) i;
		return pvalue;
	end tot_purchase_val;
member function tot_profit return float is
	profit float;
	begin
		select sum((i.company.cprice-i.pprice)*i.qty) into profit
		from table(self.investments) i;
		return profit;
	end tot_profit;
end;

----------------------------------------------------------



select s.company,e.column_value,s.yield(),s.AUDtoUSD(0.74)
from stock_tbl s,table(s.ex_traded) e

select s.company,s.cprice,s.no_of_trades()
from stock_tbl s
where s.no_of_trades()>1

select distinct c.name,i.company.company,i.company.yield(),i.company.cprice,i.company.eps 
from client_tbl c,table(c.investments) i

select c.name,c.tot_purchase_val()
from client_tbl c

select c.name,c.tot_profit()
from client_tbl c
