clear
clc

tic

% number of initial population
fighters = 8;
% number of generations
generations = 5;

% Create random weigths for the initial population
population = 20*rand(generations+1,fighters,70)-10;


for generation = 1:generations
    generation
    for match=1:fighters/2
        
        % Start not doing anything
        forward1 = 0;
        rigth1 = 0;
        left1 = 0;
        shoot1 = 0;
        wider_field_vis1=0;
        forward2 = 0;
        rigth2 = 0;
        left2 = 0;
        shoot2 = 0;
        wider_field_vis2 = 0;
        
        % Start position
        p1_pos =[100 250];
        p1_ang = pi/2;
        p2_pos =[400 250];
        p2_ang =-pi/2;
        ang_v1 = pi/36;
        ang_v2 = pi/36;
        
        % No bullets at the beginning
        bullet_1_exist = 0;
        bullet_2_exist = 0;
        bullet1_pos = [-100 -100];
        bullet2_pos = [-100 -100];
        bullet1_ang =0;
        bullet2_ang =0;
        
        % No score at the beginning
        score1 = 0;
        score2 = 0;
        
        
        % for each two players, get the DNA and put in weight format
        DNA1 = population(generation,match*2-1,:);
        DNA2 = population(generation,match*2,:);
        weight1 = {[DNA1(1:5); DNA1(6:10); DNA1(11:15); DNA1(16:20)] [DNA1(21:25);DNA1(26:30); DNA1(31:35); DNA1(36:40); DNA1(41:45)] [ DNA1(46:50);DNA1(51:55); DNA1(56:60); DNA1(61:65); DNA1(66:70)]};
        weight2 = {[DNA2(1:5); DNA2(6:10); DNA2(11:15); DNA2(16:20)] [DNA2(21:25);DNA2(26:30); DNA2(31:35); DNA2(36:40); DNA2(41:45)] [ DNA2(46:50);DNA2(51:55); DNA2(56:60); DNA2(61:65); DNA2(66:70)]};
        
        % Ready, steady, go
        for turn= 1:1000
            
            % Is enemy seen?
            p1_ene_v = seen( p2_pos, p1_pos, p1_ang, ang_v1, 9000 );
            p2_ene_v = seen( p1_pos, p2_pos, p2_ang, ang_v2, 9000 );
            % Is enemy bullet seen?
            p1_bullet_v = seen( bullet2_pos, p1_pos, p1_ang, ang_v1, 9000 );
            p2_bullet_v = seen( bullet1_pos, p2_pos, p2_ang, ang_v2, 9000 );
            
            % Extract the action with this inputs
            action1 = nn([4,5,5], weight1, [p1_ene_v p1_bullet_v ~bullet_1_exist ang_v1]);
            action2 = nn([4,5,5], weight2, [p2_ene_v p2_bullet_v ~bullet_2_exist ang_v2]);
            
            % Do your moves
            forward1 = round(action1(1));
            rigth1 = round(action1(2));
            left1 = round(action1(3));
            shoot1 = round(action1(4));
            wider_field_vis1 = 2*action1(5)-1;
            forward2 = round(action2(1));
            rigth2 = round(action2(2));
            left2 = round(action2(3));
            shoot2 = round(action2(4));
            wider_field_vis2 = 2*action2(5)-1;
            
            % Game rules
            if(forward1 == 1),p1_pos = p1_pos + [cos(p1_ang) sin(p1_ang)];end
            if(rigth1 == 1),p1_ang = p1_ang - pi/72; end
            if(left1 == 1),p1_ang = p1_ang + pi/72; end
            if(shoot1 == 1 && bullet_1_exist == 0),bullet1_pos = p1_pos; bullet1_ang = p1_ang; bullet_1_exist = 1; end
            ang_v1 = ang_v1 + wider_field_vis1 * pi/72;
            if(bullet_1_exist == 1), bullet1_pos = bullet1_pos + 5*[cos(bullet1_ang) sin(bullet1_ang)];end
            if((p1_pos(1)-bullet2_pos(1))*(p1_pos(1)-bullet2_pos(1))+(p1_pos(2)-bullet2_pos(2))*(p1_pos(2)-bullet2_pos(2))<400)
                bullet_2_exist = 0; score2 = score2+1; bullet2_pos = [-100 -100]; end
            
            if(forward2 == 1),p2_pos = p2_pos + [cos(p2_ang) sin(p2_ang)];end
            if(rigth2 == 1),p2_ang = p2_ang - pi/72; end
            if(left2 == 1),p2_ang = p2_ang + pi/72; end
            if(shoot2 == 1 && bullet_2_exist == 0),bullet2_pos = p2_pos; bullet2_ang = p2_ang; bullet_2_exist = 1; end
            ang_v2 = ang_v2 + wider_field_vis2 * pi/72;
            if(bullet_2_exist == 1), bullet2_pos = bullet2_pos + 5*[cos(bullet2_ang) sin(bullet2_ang)];end
            if((p2_pos(1)-bullet1_pos(1))*(p2_pos(1)-bullet1_pos(1))+(p2_pos(2)-bullet1_pos(2))*(p2_pos(2)-bullet1_pos(2))<400)
                bullet_1_exist = 0; score1 = score1+1; bullet1_pos = [-100 -100]; end
            
            
            %  boundary of the match
            if(p1_pos(1)>200),p1_pos(1)=200;end
            if(p1_pos(2)>500),p1_pos(2)=500;end
            if(p2_pos(1)>500),p2_pos(1)=500;end
            if(p2_pos(2)>500),p2_pos(2)=500;end
            if(p1_pos(1)<0),p1_pos(1)=0;end
            if(p1_pos(2)<0),p1_pos(2)=0;end
            if(p2_pos(1)<300),p2_pos(1)=300;end
            if(p2_pos(2)<0),p2_pos(2)=0;end
            
            if(bullet1_pos(1)<0),bullet_1_exist=0;bullet1_pos = [-100 -100];end
            if(bullet1_pos(2)<0),bullet_1_exist=0;bullet1_pos = [-100 -100];end
            if(bullet1_pos(1)>500),bullet_1_exist=0;bullet1_pos = [-100 -100];end
            if(bullet1_pos(2)>500),bullet_1_exist=0;bullet1_pos = [-100 -100];end
            if(bullet2_pos(1)<0),bullet_2_exist=0;bullet2_pos = [-100 -100];end
            if(bullet2_pos(2)<0),bullet_2_exist=0;bullet2_pos = [-100 -100];end
            if(bullet2_pos(1)>500),bullet_2_exist=0;bullet2_pos = [-100 -100];end
            if(bullet2_pos(2)>500),bullet_2_exist=0;bullet2_pos = [-100 -100];end
            if(ang_v1>pi/18),ang_v1=pi/18;end
            if(ang_v2>pi/18),ang_v2=pi/18;end
            if(ang_v1<pi/100),ang_v1=pi/100;end
            if(ang_v2<pi/100),ang_v2=pi/100;end
        end
        
        % Fighter with better score survive, Coliseum style
        if(score1>=score2),population(generation+1,match,:)= population(generation,match*2-1,:); score(generation,match) = score1;
        else population(generation+1,match,:)= population(generation,match*2,:); score(generation,match) = score2;end
    end
    
    % Winner fighters have children mixing their DNA randomly
    for crossover=1:fighters/2
        mix=round(rand(1,1,70));
        population(generation+1,fighters/2+crossover,:)= population(generation+1,ceil(fighters/2*rand()),:).*mix+population(generation+1,ceil(fighters/2*rand()),:).*(~mix);
    end
    
    % Children get a random gen
    for mutated=1:fighters/2
        population(generation+1,fighters/2+mutated,ceil(rand()*70))= 20*rand()-10;
    end
    
end

toc