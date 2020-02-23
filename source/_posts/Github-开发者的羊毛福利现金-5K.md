---
title: Github 开发者的羊毛福利现金 5K
date: 2020-02-23 15:05:05
tags:
---

Namebase 正在举行一场空投活动，满足条件的开发者，可以获得大约 4200 个 HNS 代币的奖励，折合人民币的价值，目前大约在 5000 元左右，我从多个可信渠道证实这个活动是真实有效的。

首先要明确的是，不是所有开发者都有资格参与，必须满足以下条件：

* 有 Github 账号
* GitHub 账号粉丝数量(followers)在 2019 年 2 月04日之前超过 15 名
* GitHub 账号在2019 年 2 月04日之前绑定的SSH Key 或 GPG key还在
* 领币需要验证身份证，风险自己评估(不过身边的朋友到账了没发现有什么问题)

注意：namebase 已经做过快照，所以现在去互关增加粉丝是没有用的

### 详细步骤：

首先打开活动的地址：https://www.namebase.io/airdrop：根据提示通过Github登录

```
git clone https://github.com/handshake-org/hs-airdrop.git
```
记得npm需要代理， 不行用 cnpm

 cd hs-airdrop && npm install


打开页面 https://www.namebase.io/airdrop， 在第四步生成 key， 执行下面命令替换key

执行 /bin/hs-airdrop ~/.ssh/id_rsa key 0.010

执行过程中需要设定密码： 

可以看到输出结果有：
Base64 (pass this to $ hsd-rpc sendrawairdrop):
g+gCABI0Sz+Xf3YKOx9NUHrqYoLDLjX0c3CtEKRgwW8vsb14i4L+gVooKsYyoO5uY6FQ2GwV1kusT9LqoNiMz2oJYvj1CH9IUdSWqOzt/Hp15jHF17iZ+b+qmJYaInHXf4zTc5UE+fakzj5MHoIINCHPZl4DWdj/SljMa/vhiVaH/D4X3BQLcSz6aCAyrkTSw9RYQh0UrVGQMYshiGDUBRZyvWSTbWgwrvDeyefvV8TIvbMZ3aY0rJSGX/7EOQSJHDjzbHcJTHVhicLYGpbNCjQ+IAcYPKYnNfXMfjnXAocCAPUg0kToeFpi/Zhd93HSw6LSs/e6xI+t4cP85t+FO9OKmROrP7y0HROwtgbR3gqo+mr2ExVIsC8gG9qMucantdogOF1HXQtVZq07gyGImg0QLnEXe+WZ34YDlkiZXUMcqukzVy13mUc0b6ae1l/cZGm49mHWiJeTFT4+HUyv+amdZA03lpcpPKd+ehb/uUeuI3fIb3+sGHjkWpNInqNyp0SRLKmfPo9tVeH32gmM0QnuuIaFVtmtcOVDfD+FNrp1VqY4UL/KX6hr5xxnq46cZaXG7gzpwJU7Mrgq/UfYN7Nw6/fFkz9r0bMHuSWmO/3eYvbw5EJtQVbF9gW0+QC/G5MbQUetjSRPUiSIATf+wcl7CVjm+EaDK+uyqor3GKAzAvzim5rMdshk1PGfcRsCm1ODEUAlv8AiLbIkOgDQ+qunCGv8C2uqLXEsMphvMML0zffMNa/Ou9bjafG6txihmItRu4EGA63uQGY9sM+5ZiaJV71KLHiqp8cMU7Ug0cLnBpCr1M86Btp3OIg9XF8VGQgftoYw7uwGDihAiVdx8mPm0kgAxC0kmFvOTUBwuspZ+dDtxeWLPp3gPDmKu+uD9Zg0+AHWQv0BAQEKpCgnGBIOqSc1XCDIobXMh0Jd21Om1oPoCpJXzJ/BZsA3Jw1W+vc1uroa3l2bcA7m1qjYd+KYO3vffIupOfHXO2S7ac7RWusdWGoMf+3SEui3LIrQV+1LmU/BQ7HCAykVxAYNtGnQBPSCXHJHcmQM7tSghJ2+YCBhjRIc47tik90Lhb8ij9fbmiLaho89zPCV8eQA05igPLPciJhWb70ijcFf0N8DRC1y9zG7TkaRV40XXmVnDeQHxj/nq4cIdeWEzHSUELtSn4i2377EtRHDZ8W6A8wh9Dq5KyLYpbH2TegljzLY7P8deIgXiScH6/YrUwMhUnf91vB2tefsWRseABTbJlB4dkCCUHF4N05PgTx6f25jrf6ghgEA/awHRnJzggS1PDblqx3ZrlW42dlHMrW4pDJk3G66L2Eu7PGvrcEe/qkmlfDL8jbtnYdsa6cnOeRm4thVysN0IOc6mxnqE8Yol4uKWRy/IgfvZdoTHRDYAurWZGJZXzRBKPfQyMSup7KlQSfqWC8qiF612VZ7hVuFCH4f5Xw3RsgCKPvHWqW3hTXLCelZgsdWDcO1khwJqc+U9HmclZUYz6hc

最后提交到页面： https://www.namebase.io/airdrop 的第五步，如果成功，会弹出提示框等待15小时

等待到账， 然后转入你的钱包，就可以去火币交易·