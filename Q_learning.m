clear
R = -0.04;
r = 0.9;
a = 0.001;
e = 0.7;
A = ["U","L","D","R"];
terminal = [4,3];
w0 = 0;
w1 = 0;
w2 = 0;
w3 = 0;
s = [1,1];
for t = 1:1000
    sp = [s(1),s(2) + 1;s(1) - 1,s(2);s(1),s(2) - 1;s(1) + 1,s(2)];
    for i = 1:4
        if (sp(i,1) == 2 && sp(i,2) == 2)
            sp(i,1:2) = s;
        end
        if (sp(i,1) > 4 || sp(i,2) > 3 || sp(i,1) < 1 || sp(i,2) < 1)
            sp(i,1:2) = s;
        end
    end
    Q = w0 + w1 * s(1) + w2 * s(2) + w3 * norm(terminal - s);
    Qp = zeros(1,4);
    for i = 1:4
        Qp(i) = w0 + w1 * sp(i,1) + w2 * sp(i,2) + w3 * norm(terminal - sp(i)); 
    end
    x = randi([1,10],1,1);
    b = 0;
    if (x <= 7)
        p = find(Qp == max(Qp));
        y = randi([1,length(p)],1,1);
        b = p(y);
    end
    if (x > 7)
        b = randi([1,4],1,1);
    end
    if (sp(b,1) == 4 && sp(b,2) == 3)
        d = a * (1 + r * Qp(b) - Q);
    end
    if (sp(b,1) == 4 && sp(b,2) == 2)
        d = a * (-1 + r * Qp(b) - Q);
    end
    if ((sp(b,1) ~= 4 && sp(b,2) ~= 2) || (sp(b,1) ~= 4 && sp(b,2) ~= 3))
        d = a * (-0.1 + r * Qp(b) - Q);
    end
    if (s(1) ~= 4 && s(2) ~= 3)
        w0 = w0 + d;
        w1 = w1 + d * s(1);
        w2 = w2 + d * s(2);
        w3 = w3 + d * norm(terminal - s);
    end
    figure(1)
    clf;
    theta = 0:0.1:2 * pi + 0.1;
    for i = 0:3
        for j = 0:2
            h = rectangle('Position',[i,j,1,1]);
            if((i == 1) && (j == 1))
              h.FaceColor = 'k';
            end
            hold on;
        end
    end
    circle1 = s(1) - 1 + 0.5 + 0.1 * cos(theta);
    circle2 = s(2) - 1 + 0.5 + 0.1 * sin(theta);
    plot(circle1,circle2,'k');
    text(s(1) - 1 + 0.2,s(2) - 0.1,num2str(Qp(1)));
    text(s(1) - 1 - 0.2,s(2) - 1 + 0.5,num2str(Qp(2)));
    text(s(1) - 1 + 0.2,s(2) - 0.9,num2str(Qp(3)));
    text(s(1) - 1 + 0.8,s(2) - 1 + 0.5,num2str(Qp(1)));
    text(s(1) - 0.5,s(2) - 0.5,A(b));
    text(0,-0.1,"w0: " + num2str(w0));
    text(0,-0.3,"w1: " + num2str(w1));
    text(1,-0.1,"w2: " + num2str(w2));
    text(1,-0.3,"w3: " + num2str(w3));
    box off;
    axis off;
    pause(0.1);
    if ((s(1) == 4 && s(2) == 3) || (s(1) == 4 && s(2) == 2))
        s = [1,1];
    else
        s = sp(b,:);
    end
end