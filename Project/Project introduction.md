# The SME309 Project Introduction

## Q1
第一问是让我们完成一个处理器的流水线结果，并且用Forwarding，Stall，Flush来处理各类出现的Hazard。

Hazard 分类（Data hazard, Control hazard）
下面我们分别讲一下我们的解决策略，由于这部分上课讲的也比较清晰，所以我们不做过多的解释。

这边建议直接抄PPT，把PPT上的Forwding图，解决策略和代码一抄就好了。

![90fe021adad33eb4e3254f86d7ab8e8](./Photo for Project introduction/90fe021adad33eb4e3254f86d7ab8e8.jpg)

以下是我们不太一样的地方：

（1）我们的寄存器模块分为两部分，一部分是data的寄存器，一部分是condition的寄存器。主要原因是希望在之前的代码基础上不作过多的改动，之前代码Decoder和CondLogic都在Control Unit里面，所以这边我们在Control Unit里面添加寄存器，状态的寄存器包括了D2E，E2M，M2W。并在某个信号该输出的地方输出，不会将其它多余的wire信号放在我们的顶层中，简化了代码，增加了可读性。

（2）由于新的图不包括shift和Mcycle模块，所以我们这边要添加Shift和Mcycle。我们把这两个值添加到如下图所示的地方，shift添加到E层,主要原因是Mcycle使用的是不移位的Register值。所以我们要保留原本的操作数留到E层，一个直接给MCycle，一个给ALU部分。

（3）对于Mcycle，我们将Mcycel和之前一样，放到和ALU同级别的地方，可以这样认为，使用Mcycle的时候就不能用ALU，当Mcycle运行的时候，将Busy信号输出，把所有的寄存器模块阻塞（第一问）。其它对于更详细的Mcycle流程，就不在Q1地方详细描述了，我们会将这部分移动至Q2的时候介绍它的工作流程.

我们利用Lab2的testbench进行了充分的仿真，仿真波形图如下（regbank）：

汇编语言如下：



## Q2 Non-stalling CPU for multi-cycle instructions.

在Non-stalling的处理中，我们可以通过在MCycle运行过程中不出现Hazard开始，一步步的来思考我们需要做什么。

1、首先第一步就是，我们需要记录MCycle计算的数据输出到哪里去，这里就要保存下Addr的值；

2、同时当数据计算出来的时候，我们暂停掉当前即将输出E的数据（并保存），并将这个数据替换成MCycle的输出值。

3、最后对于Condition Unit模块输出值，PCSrc = 0, RegWrite = 1&Exution(是否运行)，MemWrite = 0，这几个值都要在MCycle输出的周期同时输出。

搞清楚不出现Hazard的情况，出现Hazard的情况就比较好做了。

1、判断Hazard用我们第一步存下的MCycle的目标地址来和RA1和RA2来进行判断或者下一个指令是否要启动MCycle，如果相同，将会对F，D stage暂停，对E stage清除（相当于插入Nop），这一步相当于暂停前面F，D，E stage的运行，并让M和W周期的值不受影响（因为他们没有问题）。直到MCycle完成计算。

在考虑完需要做什么之后，下一步我们进行分析，怎么实现：

对于第一条，我们需要构造一个reg寄存器，来存输出地址的值。

对于第二条，我们构建了一个MCycle_out的值，MCycle_out = Busy_reg & ~i_Busy; Busy_reg是保存上一个周期是否是Busy，这个代码其实就是为了得到Busy的下降沿周期，在该周期我们进行暂停并输出真实结果。这个结果将会连接到Stall F, D, E，暂停这三个Stage的信号。

对于第三条，我们再次利用MCycle_out这个值，当用Mcycle_out拉高时，这三个信号分别置为0，1，0。在实际设计的过程中，我们不需要考虑是否运行的情况，因为当该指令不运行的时候Start信号不会来搞，整个MCycle模块都不会运行。

对于Hazard的情况，我们新创立MCycle_Stall = MCycle_Stall = ((MCycle_addr=RA1) || (MCycle_addr=RA2) || StartD) && Busy;

经过上述步骤Q2完成，下面是我们的tb波形验证：

下面是我们的tb的汇编语言：

![image-20240118044620742](./Photo for Project introduction/image-20240118044620742.png)



## Q3 Expand the ARM processor to support all the 16 Data Processing Instructions.

在写第三题的时候，我们详细读了Arm的开发手册
