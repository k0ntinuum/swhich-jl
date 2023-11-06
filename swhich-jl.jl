function key(n,l) 
    k = []
    push!(k, rand(0:n-1,l))
    push!(k, rand(0:n-1,l))
    k
end


function str(v,s)
    #out_alph = "abcdefghijklmnopqrstuvwxyz_"
    out_alph = "O|"
    join(map(i -> out_alph[i+1:i+1] * s,v ))
end
rgb(r,g,b) =  "\e[38;2;$(r);$(g);$(b)m"
red() = rgb(255,0,0)
yellow() = rgb(255,255,0)
white() = rgb(255,255,255)
gray(h) = rgb(h,h,h)


function print_key(f) 
    print(white(),"f = \n", str(f[1],""),"\n", str(f[2],""),"\n")
end

function swhich!(f)
    f[1] = [f[1][1:end];f[2][1]] 
    f[2] = [f[2][2:end];f[1][1]]
    popfirst!(f[1])
end

function print_vec(v)
    print(str(v,""),"\n")
end



function encode(p,q,n)
    f = deepcopy(q)
    c = Int64[]
    for i in eachindex(p)
        push!(c, ( f[1][1] + f[2][1] + p[i] )%n )
        swhich!(f)
        f[1][1] = (f[1][1] + p[i])%n
    end
    c
end

function decode(c,q,n)
    f = deepcopy(q)
    p = Int64[]
    for i in eachindex(c)
        push!(p, ( 2*n + c[i]  - f[1][1] - f[2][1])%n )
        swhich!(f)
        f[1][1] = (f[1][1] + p[i])%n
    end
    p
end

function encrypt(p,q,n)
    l = length(q)
    for i in 1:l
        f = deepcopy(q)
        f = circshift(f,i)
        p = encode(p,f,n)
        p = reverse(p)
    end
    p
end

function decrypt(c,q,n)
    l = length(q)
    for i in 1:l
        f = circshift(q, l + 1 - i)
        c = reverse(c)
        c = decode(c,f,n)
    end
    c
end

function swhich_demo(n)
    l = 40
    f = key(n,l)
    print_key(f)
    for i in 2:l
        swhich!(f)
        print_key(f)
    end
end



function demo(n)
    l = 32
    f = key(n,l)
    print_key(f)
    println()
    for i in 1:10
        p = rand(0:n-1,2*l)
        print(red())
        print_vec(p)
        c = encrypt(p,f,n)
        print(yellow())
        print_vec(c)
        println()
        d = decrypt(c,f,n)
        if p != d print("\nERROR\n") end
    end
end
    








