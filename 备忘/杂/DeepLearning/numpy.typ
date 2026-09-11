#let pc(use)={
raw(use,lang:"python")
}

#let numpy_make()={
    [
        #table(columns:(auto,auto,auto,auto),
  [`array`],[创建数组],[```python np.array([1,2.3])```],[```python np.array([[1,2.3],[4,5,6]])```]
  ,[`zeros`],[全0数组],[
    ```python np.zeros(shape=(3,4)) # 3x4 matrix```
  ],[],
  [`ones`],[全1数组],[
    ```python np.ones(shape=(3,4)) # 3x4 matrix```
  ],[],
  [`empty`],[创建全空数组],[...],[],
  [`arrange`],[创建等长],[#pc("np.arange(a,b,c)")],[$x_0=a,x_(i+1)=x_i+c,x_i in[a,b)$],
  [`linspace`],[创建n个等分],[#pc("np.linspace(a,b,c)")],[$x_i in [a,b],n=c,forall j,x_(j+1)-x_j=x_j-x_(j-1)$],
  [`rand`],[随机数组],[#pc("np.random.rand(3,4)")],[#pc("np.random.randint(2,5,size=(3,4))")],

  )
    ]
}
