classdef Node
    properties
        x;         
        y;          
        parent;    
    end

    methods
        function node = Node(x, y)
            node.x = x;
            node.y = y;
            node.parent = [];  
        end
    end
end
