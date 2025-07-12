<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Extension\CoreExtension;
use Twig\Extension\SandboxExtension;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;
use Twig\TemplateWrapper;

/* modules/custom/openrisk_navigator/templates/loan-record.html.twig */
class __TwigTemplate_1e8518eafecd4e7f14419bd8a7446f6d extends Template
{
    private Source $source;
    /**
     * @var array<string, Template>
     */
    private array $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
        ];
        $this->sandbox = $this->extensions[SandboxExtension::class];
        $this->checkSecurity();
    }

    protected function doDisplay(array $context, array $blocks = []): iterable
    {
        $macros = $this->macros;
        // line 16
        yield "
<article";
        // line 17
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, CoreExtension::getAttribute($this->env, $this->source, ($context["attributes"] ?? null), "addClass", ["loan-record", ("loan-record--" . ($context["view_mode"] ?? null))], "method", false, false, true, 17), "html", null, true);
        yield ">
  
  ";
        // line 19
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, ($context["title_prefix"] ?? null), "html", null, true);
        yield "
  ";
        // line 20
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, ($context["title_suffix"] ?? null), "html", null, true);
        yield "

  <div class=\"loan-record__container\">
    
    ";
        // line 25
        yield "    <header class=\"loan-record__header\">
      <div class=\"loan-record__title-section\">
        <h1 class=\"loan-record__title\">
          Loan Record
        </h1>
        <div class=\"loan-record__loan-id\">
          ";
        // line 31
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "loan_id", [], "any", false, false, true, 31), "html", null, true);
        yield "
        </div>
      </div>
      
      <div class=\"loan-record__status-section\">
        <div class=\"loan-record__default-status ";
        // line 36
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->renderVar((((($tmp = CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, (($_v0 = CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "defaulted", [], "any", false, false, true, 36)) && is_array($_v0) || $_v0 instanceof ArrayAccess && in_array($_v0::class, CoreExtension::ARRAY_LIKE_CLASSES, true) ? ($_v0["#items"] ?? null) : CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "defaulted", [], "any", false, false, true, 36), "#items", [], "array", false, false, true, 36)), 0, [], "any", false, false, true, 36), "value", [], "any", false, false, true, 36)) && $tmp instanceof Markup ? (string) $tmp : $tmp)) ? ("defaulted") : ("current")));
        yield "\">
          <span class=\"status-label\">Status:</span>
          <span class=\"status-value\">
            ";
        // line 39
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->renderVar((((($tmp = CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, (($_v1 = CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "defaulted", [], "any", false, false, true, 39)) && is_array($_v1) || $_v1 instanceof ArrayAccess && in_array($_v1::class, CoreExtension::ARRAY_LIKE_CLASSES, true) ? ($_v1["#items"] ?? null) : CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "defaulted", [], "any", false, false, true, 39), "#items", [], "array", false, false, true, 39)), 0, [], "any", false, false, true, 39), "value", [], "any", false, false, true, 39)) && $tmp instanceof Markup ? (string) $tmp : $tmp)) ? ("Defaulted") : ("Current")));
        yield "
          </span>
        </div>
      </div>
    </header>

    ";
        // line 46
        yield "    <section class=\"loan-record__metrics\">
      <h2 class=\"section-title\">Key Loan Metrics</h2>
      
      <div class=\"metrics-grid\">
        <div class=\"metric-card metric-card--primary\">
          <div class=\"metric-label\">Loan Amount</div>
          <div class=\"metric-value\">";
        // line 52
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "loan_amount", [], "any", false, false, true, 52), "html", null, true);
        yield "</div>
        </div>
        
        <div class=\"metric-card metric-card--score\">
          <div class=\"metric-label\">FICO Score</div>
          <div class=\"metric-value\">";
        // line 57
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "fico_score", [], "any", false, false, true, 57), "html", null, true);
        yield "</div>
        </div>
        
        <div class=\"metric-card metric-card--ratio\">
          <div class=\"metric-label\">LTV Ratio</div>
          <div class=\"metric-value\">";
        // line 62
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "ltv_ratio", [], "any", false, false, true, 62), "html", null, true);
        yield "</div>
        </div>
        
        <div class=\"metric-card metric-card--ratio\">
          <div class=\"metric-label\">DTI Ratio</div>
          <div class=\"metric-value\">";
        // line 67
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "dti", [], "any", false, false, true, 67), "html", null, true);
        yield "</div>
        </div>
      </div>
    </section>

    ";
        // line 73
        yield "    <section class=\"loan-record__borrower-info\">
      <h2 class=\"section-title\">Borrower Information</h2>
      
      <div class=\"info-grid\">
        <div class=\"info-item\">
          <span class=\"info-label\">Borrower Name:</span>
          <span class=\"info-value\">";
        // line 79
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, (($_v2 = CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "borrower_name", [], "any", false, false, true, 79)) && is_array($_v2) || $_v2 instanceof ArrayAccess && in_array($_v2::class, CoreExtension::ARRAY_LIKE_CLASSES, true) ? ($_v2["#items"] ?? null) : CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "borrower_name", [], "any", false, false, true, 79), "#items", [], "array", false, false, true, 79)), 0, [], "any", false, false, true, 79), "value", [], "any", false, false, true, 79), "html", null, true);
        yield "</span>
        </div>
        
        <div class=\"info-item\">
          <span class=\"info-label\">State:</span>
          <span class=\"info-value\">";
        // line 84
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "borrower_state", [], "any", false, false, true, 84), "html", null, true);
        yield "</span>
        </div>
        
        <div class=\"info-item\">
          <span class=\"info-label\">Loan ID:</span>
          <span class=\"info-value\">";
        // line 89
        yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, (($_v3 = CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "loan_id", [], "any", false, false, true, 89)) && is_array($_v3) || $_v3 instanceof ArrayAccess && in_array($_v3::class, CoreExtension::ARRAY_LIKE_CLASSES, true) ? ($_v3["#items"] ?? null) : CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "loan_id", [], "any", false, false, true, 89), "#items", [], "array", false, false, true, 89)), 0, [], "any", false, false, true, 89), "value", [], "any", false, false, true, 89), "html", null, true);
        yield "</span>
        </div>
      </div>
    </section>

    ";
        // line 95
        yield "    ";
        if ((($tmp = CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, (($_v4 = CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "risk_summary", [], "any", false, false, true, 95)) && is_array($_v4) || $_v4 instanceof ArrayAccess && in_array($_v4::class, CoreExtension::ARRAY_LIKE_CLASSES, true) ? ($_v4["#items"] ?? null) : CoreExtension::getAttribute($this->env, $this->source, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "risk_summary", [], "any", false, false, true, 95), "#items", [], "array", false, false, true, 95)), 0, [], "any", false, false, true, 95), "value", [], "any", false, false, true, 95)) && $tmp instanceof Markup ? (string) $tmp : $tmp)) {
            // line 96
            yield "    <section class=\"loan-record__risk-analysis\">
      <h2 class=\"section-title\">Risk Analysis</h2>
      
      <div class=\"risk-analysis-content\">
        ";
            // line 100
            yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, CoreExtension::getAttribute($this->env, $this->source, ($context["content"] ?? null), "risk_summary", [], "any", false, false, true, 100), "html", null, true);
            yield "
      </div>
    </section>
    ";
        }
        // line 104
        yield "
    ";
        // line 106
        yield "    <section class=\"loan-record__additional\">
      ";
        // line 107
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["content"] ?? null));
        foreach ($context['_seq'] as $context["field_name"] => $context["field_content"]) {
            // line 108
            yield "        ";
            if (((Twig\Extension\CoreExtension::first($this->env->getCharset(), $context["field_name"]) != "#") && !CoreExtension::inFilter($context["field_name"], ["borrower_name", "loan_id", "loan_amount", "fico_score", "ltv_ratio", "dti", "borrower_state", "defaulted", "risk_summary"]))) {
                // line 109
                yield "          <div class=\"additional-field\">
            <span class=\"field-label\">";
                // line 110
                yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, (($_v5 = $context["field_content"]) && is_array($_v5) || $_v5 instanceof ArrayAccess && in_array($_v5::class, CoreExtension::ARRAY_LIKE_CLASSES, true) ? ($_v5["#title"] ?? null) : CoreExtension::getAttribute($this->env, $this->source, $context["field_content"], "#title", [], "array", false, false, true, 110)), "html", null, true);
                yield ":</span>
            <span class=\"field-value\">";
                // line 111
                yield $this->extensions['Drupal\Core\Template\TwigExtension']->escapeFilter($this->env, $context["field_content"], "html", null, true);
                yield "</span>
          </div>
        ";
            }
            // line 114
            yield "      ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['field_name'], $context['field_content'], $context['_parent']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 115
        yield "    </section>

  </div>
  
</article>
";
        $this->env->getExtension('\Drupal\Core\Template\TwigExtension')
            ->checkDeprecations($context, ["attributes", "view_mode", "title_prefix", "title_suffix", "content"]);        yield from [];
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "modules/custom/openrisk_navigator/templates/loan-record.html.twig";
    }

    /**
     * @codeCoverageIgnore
     */
    public function isTraitable(): bool
    {
        return false;
    }

    /**
     * @codeCoverageIgnore
     */
    public function getDebugInfo(): array
    {
        return array (  214 => 115,  208 => 114,  202 => 111,  198 => 110,  195 => 109,  192 => 108,  188 => 107,  185 => 106,  182 => 104,  175 => 100,  169 => 96,  166 => 95,  158 => 89,  150 => 84,  142 => 79,  134 => 73,  126 => 67,  118 => 62,  110 => 57,  102 => 52,  94 => 46,  85 => 39,  79 => 36,  71 => 31,  63 => 25,  56 => 20,  52 => 19,  47 => 17,  44 => 16,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "modules/custom/openrisk_navigator/templates/loan-record.html.twig", "/var/www/html/web/modules/custom/openrisk_navigator/templates/loan-record.html.twig");
    }
    
    public function checkSecurity()
    {
        static $tags = ["if" => 95, "for" => 107];
        static $filters = ["escape" => 17, "first" => 108];
        static $functions = [];

        try {
            $this->sandbox->checkSecurity(
                ['if', 'for'],
                ['escape', 'first'],
                [],
                $this->source
            );
        } catch (SecurityError $e) {
            $e->setSourceContext($this->source);

            if ($e instanceof SecurityNotAllowedTagError && isset($tags[$e->getTagName()])) {
                $e->setTemplateLine($tags[$e->getTagName()]);
            } elseif ($e instanceof SecurityNotAllowedFilterError && isset($filters[$e->getFilterName()])) {
                $e->setTemplateLine($filters[$e->getFilterName()]);
            } elseif ($e instanceof SecurityNotAllowedFunctionError && isset($functions[$e->getFunctionName()])) {
                $e->setTemplateLine($functions[$e->getFunctionName()]);
            }

            throw $e;
        }

    }
}
