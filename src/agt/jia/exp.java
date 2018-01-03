package jia;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

/**
 * @author igorcadelima
 * @see Math#exp(double)
 *
 */
public class exp extends DefaultInternalAction {
  @Override
  public int getMinArgs() {
    return 1;
  }

  @Override
  public int getMaxArgs() {
    return 2;
  }
  
  @Override
  protected void checkArguments(Term[] args) throws JasonException {
    super.checkArguments(args);
    if (!args[0].isNumeric()) {
      throw new JasonException(
          "The first argument of the internal action " + getClass().getCanonicalName() + " is not a number.");
    } else if (!args[1].isVar()) {
      throw new JasonException(
          "The second argument of the internal action " + getClass().getCanonicalName() + " is not a variable.");
    }
  } 

  @Override
  public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    double power = ((NumberTerm) args[0]).solve();
    final NumberTerm result = ASSyntax.createNumber(power);
    return un.unifies(result, args[1]);
  }
}
