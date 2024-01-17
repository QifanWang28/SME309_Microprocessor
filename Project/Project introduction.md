# The SME309 Project Introduction

## Q1
第一问是让我们完成一个处理器的流水线结果，并且用Forwarding，Stall，Flush来处理各类出现的Hazard。

Hazard 分类（Data hazard, Control hazard）
下面我们分别讲一下我们的解决策略，由于这部分上课讲的也比较清晰，所以我们不做过多的解释。

这边建议直接抄PPT，把PPT上的Forwding图，解决策略和代码一抄就好了。

以下是我们不太一样的地方：

（1）我们的寄存器模块分为两部分，一部分是data的寄存器，一部分是condition的寄存器。主要原因是希望在之前的代码基础上不作过多的改动，之前代码Decoder和CondLogic都在Control Unit里面，所以这边我们在Control Unit里面添加寄存器，状态的寄存器包括了D2E，E2M，M2W。并在某个信号该输出的地方输出，不会将其它多余的wire信号放在我们的顶层中，简化了代码，增加了可读性。

（2）由于新的图不包括shift和Mcycle模块，所以我们这边要添加Shift和Mcycle。我们把这两个值添加到如下图所示的地方，shift添加到E层,主要原因是Mcycle使用的是不移位的Register值。是直接从Register处，拿到Mcycle的操作数。

（3）对于Mcycle，我们将Mcycel和之前一样，放到和ALU同级别的地方，可以这样认为，使用Mcycle的时候就不能用ALU，当Mcycle运行的时候，将Busy信号输出，把所有的寄存器模块阻塞。

