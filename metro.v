`timescale 1ns / 1ps

module metro_istasyonu(
    input clk,
    input switch_yon,
    input [5:0] switch_first,
    output dp,
    output [6:0]sseg,
    output [3:0] an, 
    output reg [5:0] leds
    );
    
    assign dp = 1;
    reg [17:0]count;  
    reg [6:0] sseg_tmp; 
    reg [3:0] an_tmp;  
    
    reg [6:0] a;        
    reg [83:0] durak_adi; 
    reg saniyelik_clk;  
    reg [31:0] clk_sayaci;  
    reg [5:0] durak_sayaci; 
    reg [4:0] saniye_sayaci;    
    reg [5:0]s=0;  
    reg yon;
    
    initial begin
        clk_sayaci=32'd0;
        saniyelik_clk=1'b1;
        saniye_sayaci=0;
        leds=6'b000_000;
        durak_adi = 0;
        durak_adi =~durak_adi;  
        sseg_tmp=7'b1111111;   
        an_tmp=0;
        count=0;
    end
    
    always @(posedge clk) begin
        if(saniye_sayaci<=19)begin  
            case(count[17:16])
              2'b00 : 
                begin
                sseg_tmp = durak_adi[83:77];
                an_tmp = 4'b1110;
                end
   
              2'b01:
                begin
                sseg_tmp =durak_adi[76:70]; 
                an_tmp = 4'b1101;
                end
   
                2'b10:
                begin
                sseg_tmp = durak_adi[69:63];
                an_tmp = 4'b1011;
                end
    
                2'b11:
                begin
                sseg_tmp = durak_adi[62:56];
                an_tmp = 4'b0111;
                end
            endcase
        end
        else begin
            an_tmp=4'b1111;
            sseg_tmp=7'b1111111;
        end
        count=count+1;
    end
    assign an=an_tmp;
    assign sseg=sseg_tmp;
  


    
    
    always@(posedge clk )begin  
        if(clk_sayaci==10**8/2)begin
            clk_sayaci=32'd1;
            saniyelik_clk=~saniyelik_clk;
        end
            clk_sayaci=clk_sayaci+1;
    end
    
    
    
    always@(posedge saniyelik_clk) begin    

        if(switch_first!=s)begin
            durak_sayaci=switch_first;
            yon=switch_yon;
            s=switch_first;
           
           case(durak_sayaci)
                6'b000_001: durak_adi[83:0] = 84'b0001000_0001001_0001000_1111111_1100000_1111001_0001001_0001000_1111111_1111111_1111111_1111111;
                6'b000_010: durak_adi[83:0] = 84'b1100000_0001000_1001000_0110001_0110000_1111111_1100000_0001000_1001000_0110001_0110000_1111111;
                6'b000_100: durak_adi[83:0] = 84'b0100100_0011000_0000001_1111010_1111111_0100100_0001000_1110001_0000001_0001001_1000001_1111111;
                6'b001_000: durak_adi[83:0] = 84'b0100001_0001000_1111010_0001000_1000011_1111111_0100001_0001000_1111010_0001000_1000011_1111111;
                6'b010_000: durak_adi[83:0] = 84'b1000100_1000010_1100000_1111111_1000100_1000010_1100000_1111111_1000100_1000010_1100000_1111111;
                6'b100_000: durak_adi[83:0] = 84'b1110000_0001001_0001001_1111111_1110000_0001001_0001001_1111111_1110000_0001001_0001001_1111111;
                default: durak_adi[83:0] = 84'b1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111;
            endcase
           
           
        end
        
        
        if(saniye_sayaci!=0 && saniye_sayaci!=23)begin   
            a=durak_adi[83:77];
            durak_adi=durak_adi<<7;
            durak_adi[6:0]=a;
        end
        
        
        if(saniye_sayaci>=0 && saniye_sayaci<=19 && durak_sayaci!=6'b000_000)begin  
            leds[5:0]=durak_sayaci[5:0];
            saniye_sayaci=saniye_sayaci+1;
        end
        
        else if(saniye_sayaci>=20 && saniye_sayaci<=22 && durak_sayaci!=6'b000_000)begin    
            leds=6'b000_000;
            saniye_sayaci=saniye_sayaci+1;
        end
        
        else if(saniye_sayaci==23 && durak_sayaci!=6'b000_000)begin 
            if(durak_sayaci==6'b100_000)begin
                yon=1;
            end
            if(durak_sayaci==6'b000_001)begin
                yon=0;
            end
            
            
            if(yon==0)begin
                durak_sayaci=durak_sayaci<<1;
            end
            else begin
                durak_sayaci=durak_sayaci>>1;
            end
            saniye_sayaci=0;
            
            durak_adi = 0;
            durak_adi =~durak_adi;
            case(durak_sayaci)
                6'b000_001: durak_adi[83:0] = 84'b0001000_0001001_0001000_1111111_1100000_1111001_0001001_0001000_1111111_1111111_1111111_1111111;
                6'b000_010: durak_adi[83:0] = 84'b1100000_0001000_1001000_0110001_0110000_1111111_1100000_0001000_1001000_0110001_0110000_1111111;
                6'b000_100: durak_adi[83:0] = 84'b0100100_0011000_0000001_1111010_1111111_0100100_0001000_1110001_0000001_0001001_1000001_1111111;
                6'b001_000: durak_adi[83:0] = 84'b0100001_0001000_1111010_0001000_1000011_1111111_0100001_0001000_1111010_0001000_1000011_1111111;
                6'b010_000: durak_adi[83:0] = 84'b1000100_1000010_1100000_1111111_1000100_1000010_1100000_1111111_1000100_1000010_1100000_1111111;
                6'b100_000: durak_adi[83:0] = 84'b1110000_0001001_0001001_1111111_1110000_0001001_0001001_1111111_1110000_0001001_0001001_1111111;
                default: durak_adi[83:0] = 84'b1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111;
            endcase
  
        end
        
    end
    
endmodule

